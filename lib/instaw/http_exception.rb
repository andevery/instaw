require 'faraday'

module Instaw
  class HttpException < Faraday::Middleware
    def call
      # @app.call(env).on_complete do |response|
      #   case response[:status].to_i
      #   when 400
      #     raise Instaw::BadRequest, error_message_400(response)
      #   when 404
      #     raise Instaw::NotFound, error_message_400(response)
      #   when 429
      #     raise Instaw::TooManyRequests, error_message_400(response)
      #   when 500
      #     raise Instaw::InternalServerError, error_message_500(response, "Something is technically wrong.")
      #   when 502
      #     raise Instaw::BadGateway, error_message_500(response, "The server returned an invalid or incomplete response.")
      #   when 503
      #     raise Instaw::ServiceUnavailable, error_message_500(response, "Instagram is rate limiting your requests.")
      #   when 504
      #     raise Instaw::GatewayTimeout, error_message_500(response, "504 Gateway Time-out")
      #   end
      # end
    end
  end
end