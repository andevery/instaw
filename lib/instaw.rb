require "instaw/version"
require "instaw/client"
require "instaw/request"
require "instaw/error"
require "instaw/http_exception"

module Instaw
  SCHEME = 'https'.freeze
  HOST = 'www.instagram.com'.freeze

  def self.endpoint
    SCHEME + '://' + HOST
  end
end
