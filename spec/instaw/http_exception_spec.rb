require 'spec_helper'

describe Instaw::HttpException do
  subject {
    class TestClient
      include Instaw::Request
    end.new
  }

  {
    400 => Instaw::BadRequest,
    404 => Instaw::NotFound,
    429 => Instaw::TooManyRequests,
    500 => Instaw::InternalServerError,
    502 => Instaw::BadGateway,
    503 => Instaw::ServiceUnavailable,
    504 => Instaw::GatewayTimeout
  }.each do |status, exception|
    context "when HTTP status is #{status}" do
      before do
        stub_get.to_return(status: status)
      end

      it "raises #{exception.name} error" do
        expect {
          subject.get('/')
        }.to raise_error(exception)
      end
    end
  end

end