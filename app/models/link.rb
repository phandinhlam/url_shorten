# frozen_string_literal: true

class Link
  include Mongoid::Document
  include Mongoid::Timestamps
  include UrlShort

  KEY_LENGTH = 8
  RETRY_MAX = 3
  DOMAIN = 'shorten.ly'

  field :url, type: String
  field :short_url, type: String

  index(short_url: 1)
  index(url: 1)

  shorten_url_with :url, :short_url, key_length: KEY_LENGTH, retry_max: RETRY_MAX, domain: DOMAIN
end
