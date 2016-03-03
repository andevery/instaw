require 'instaw/request'

module Instaw
  class Client
    include Instaw::Request

    attr_reader :cookie

    def initialize(authorized = false, cookie = nil)
      @authorized = authorized
      @cookie = cookie
    end

    def auth(username, password)
      return if authorized? && cookie && csrftoken.length > 0
      @cookie = nil
      connect
      post('/accounts/login/ajax/', {username: username, password: password}, {
        'referer' => Instaw.endpoint + '/',
        'x-csrftoken' => csrftoken,
        'x-instagram-ajax' => '1'})
      @authorized = true
    end

    private

    def connect
      get('/', {}, {'upgrade-insecure-requests' => '1'}, false)
    end

    def authorized?
      @authorized
    end
  end
end