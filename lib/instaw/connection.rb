module Instaw
  module Connection

    attr_reader :cookie

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

    def set_connection(authorized:, cookie:)
      @authorized = authorized
      @cookie = cookie
    end

    def authorized?
      @authorized || false
    end

    private

    def connect
      get('/', {}, {'upgrade-insecure-requests' => '1'}, false)
    end
  end
end