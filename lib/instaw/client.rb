Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}

require 'instaw/request'
require 'instaw/connection'

module Instaw
  class Client
    include Instaw::Request
    include Instaw::Connection
    include Instaw::Client::Searching
    include Instaw::Client::Media
  end
end