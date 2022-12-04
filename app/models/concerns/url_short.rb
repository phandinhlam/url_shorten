# frozen_string_literal: true

module UrlShort
  extend ActiveSupport::Concern

  URL_REGEX = Regexp.new(
    '[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)'
  )
  STRING_MAX_LENGTH = Settings.validation.string.length.max

  included do
    scope :by_url, ->(value) { where(origin_field => value) }
    scope :by_shorten_url, ->(value) { where(short_field => value) }

    private

    def generate_short_url
      klass = self.class
      self[klass.short_field] = KeyGeneratorService.new(
        key_length: klass.key_length, key_chars: klass.key_chars,
        klass: klass, uniqueness: true, retry_max: klass.retry_max
      ).execute!
    end
  end

  class_methods do
    def shorten_url_with(origin_field, short_field, domain:, key_length: nil, key_chars: nil, retry_max: nil)
      @key_length = key_length
      @key_chars = key_chars
      @short_field = short_field
      @origin_field = origin_field
      @domain = domain
      @retry_max = retry_max

      validates origin_field, short_field, presence: true
      validates origin_field, length: { maximum: STRING_MAX_LENGTH }, uniqueness: true,
                              format: { with: URL_REGEX }, allow_blank: true
      validates short_field, length: { maximum: STRING_MAX_LENGTH }, uniqueness: true, allow_blank: true

      define_method(:"#{origin_field}=") do |value|
        self[self.class.origin_field] = value.downcase.strip.to_s
        generate_short_url
      end

      define_method(:"full_#{short_field}") do
        "https://#{self.class.domain}/#{send(short_field)}"
      end

      class << self
        attr_reader :key_length, :key_chars, :short_field, :origin_field, :retry_max, :domain
      end
    end

    def url_exists?(value)
      by_url(value).exists?
    end

    def shorten_url_exists?(value)
      by_shorten_url(value).exists?
    end

    def encode(value)
      return if value.blank?

      obj = by_url(value).first
      return unless obj

      obj.send("full_#{short_field}")
    end

    def decode(value)
      return if value.blank? || !short_url_valid?(value)

      by_shorten_url(URI.parse(value).path.gsub('/', '')).first&.send(origin_field)
    rescue StandardError
      nil
    end

    def short_url_valid?(value)
      value =~ UrlShort::URL_REGEX && value.include?(domain)
    end
  end
end
