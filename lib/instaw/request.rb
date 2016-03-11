require 'faraday'
require 'uri'
require 'json'

module Instaw
  module Request

    def get(path, options = {}, headers = {}, ajax = true)
      request(:get, path, options, headers, ajax)
    end

    def post(path, options = {}, headers = {}, ajax = true)
      request(:post, path, options, headers, ajax)
    end

    private

    def request(method, path, options = {}, headers = {}, ajax = true)
      conn = Faraday.new(Instaw.endpoint) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
        faraday.use Instaw::HttpException
      end
      response = conn.send(method, path) do |request|
        request.headers = default_headers.merge(method: method.to_s.upcase)
                                         .merge(path: path)
                                         .merge(headers)
                                         .merge(cookie: ['ig_pr=1; ig_vw=1280', @cookie].compact.join('; '))
        if ajax
          request.headers = request.headers.merge(ajax_headers)
        end
        case method
        when :get
          request.url(URI.encode(path), options)
        when :post
          request.path = URI.encode(path)
          request.body = options unless options.empty?
        end
      end
      if response.headers['set-cookie']
        parse_cookie(response.headers['set-cookie'])
      end
      unless ajax
        return response.body
      end
      response_hash = JSON.parse(response.body)
      raise Instaw::MalformedResponseBody unless response_hash.is_a? Hash
      response_hash
    end

    def default_headers
      {
        'authority' => "#{HOST}",
        'scheme' => "#{SCHEME}",
        'accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        'accept-encoding' => 'deflate',
        'accept-language' => 'ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4',
        'cache-control' => 'no-cache',
        'cookie' => 'ig_pr=1; ig_vw=1280',
        'pragma' => 'no-cache',
        'user-agent' => 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36'
      }
    end

    def ajax_headers
      {
        'content-type' => 'application/x-www-form-urlencoded; charset=UTF-8',
        'origin' => Instaw.endpoint,
        'x-requested-with' => 'XMLHttpRequest'
      }
    end

    def csrftoken
      return "" unless @cookie
      @cookie[/csrftoken=([0-9a-z]+)/, 1] || ""
    end

    def parse_cookie(cookie_string)
      @cookie = cookie_string
                 .gsub(/expires=(\w+),\s/, "expires=#{$1} ")
                 .split(', ').map{|s| s.split('; ').first}.join('; ')
    end
  end
end