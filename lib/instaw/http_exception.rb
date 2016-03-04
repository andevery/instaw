require 'faraday'

module Instaw
  class HttpException < Faraday::Middleware
    def call(request_env)
      @app.call(request_env).on_complete do |response|
        case response[:status].to_i
        when 400
          raise Instaw::BadRequest, error_message(response, response[:body])
        when 404
          raise Instaw::NotFound, error_message(response, response[:body])
        when 429
          raise Instaw::TooManyRequests, error_message(response, response[:body])
        when 500
          raise Instaw::InternalServerError, error_message(response, "Something is technically wrong.")
        when 502
          raise Instaw::BadGateway, error_message(response, "The server returned an invalid or incomplete response.")
        when 503
          raise Instaw::ServiceUnavailable, error_message(response, "Instagram is rate limiting your requests.")
        when 504
          raise Instaw::GatewayTimeout, error_message(response, "504 Gateway Time-out")
        end
      end
    end

    private

    def error_message(response, body=nil)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{[response[:status].to_s + ':', body].compact.join(' ')}"
    end
  end
end