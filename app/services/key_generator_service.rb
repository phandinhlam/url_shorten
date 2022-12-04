# frozen_string_literal: true

class KeyGeneratorService < BaseService
  def initialize(key_length: nil, key_chars: nil, klass: nil, uniqueness: true, retry_max: 5)
    @key_length = key_length || 6
    @key_chars = key_chars || ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    @klass = klass if uniqueness
    @uniqueness = uniqueness
    @retry_count = 0
    @retry_max = retry_max
  end

  def execute!
    with_error_logger do
      key = gen_key
      return key if !uniqueness && !klass.shorten_url_exists?(key)

      loop do
        key = gen_key
        break if retry_count >= retry_max || !klass.shorten_url_exists?(key)

        @retry_count += 1
      end
      key
    end
  end

  private

  attr_reader :key_length, :key_chars, :klass, :uniqueness, :retry_count, :retry_max

  def key_chars_size
    @key_chars_size ||= key_chars.size
  end

  def gen_key
    (0...key_length).map { key_chars[rand(key_chars_size)] }.join
  end
end
