require 'instaw'
require 'webmock/rspec'

def stub_get(path = '/')
  stub_request(:get, Instaw.endpoint + path)
end

def stub_post(path = '/')
  stub_request(:post, Instaw.endpoint + path)
end