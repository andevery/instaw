require 'spec_helper'

describe Instaw::Request do
  subject {
    class TestClient
      include Instaw::Request
    end.new
  }

  let(:url) { 'https://www.instagram.com' }
  let(:headers) {{
      'authority' => 'www.instagram.com',
      'method' => 'GET',
      'path' => '/',
      'scheme' => 'https',
      'accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
      'accept-encoding' => 'gzip, deflate',
      'accept-language' => 'ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4',
      'cache-control' => 'no-cache',
      'cookie' => 'ig_pr=1; ig_vw=1280',
      'pragma' => 'no-cache',
      'user-agent' => 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36',
      'content-type' => 'application/x-www-form-urlencoded; charset=UTF-8',
      'origin' => url,
      'x-requested-with' => 'XMLHttpRequest'
  }}

  it 'sends request with correct url' do
    req = stub_request(:post, url + '/foo')
    subject.send(:request, :post, '/foo')
    expect(req).to have_been_made
  end

  it 'sends request with options' do
    options = {foo: 'bar'}
    req = stub_request(:get, url).with(query: options)
    subject.send(:request, :get, '/', options)
    expect(req).to have_been_made
  end

  it 'sends request with body' do
    options = {foo: 'bar'}
    req = stub_request(:post, url).with(body: options)
    subject.send(:request, :post, '/', options)
    expect(req).to have_been_made
  end

  it 'sends request with default headers' do
    req = stub_request(:get, url).with(headers: headers)
    subject.send(:request, :get, '/')
    expect(req).to have_been_made
  end

  it 'sends request with custom headers' do
    req = stub_request(:get, url).with(headers: headers.merge!({'upgrade-insecure-requests' => '1'}))
    subject.send(:request, :get, '/', {}, {'upgrade-insecure-requests' => '1'})
    expect(req).to have_been_made
  end

  it 'saves cookies' do
    cookie = 'foo=bar'
    req = stub_request(:get, url).to_return(headers: {'set-cookie' => cookie})
    subject.send(:request, :get, '/')
    expect(subject.instance_variable_get('@cookie')).to eq cookie
  end

  it 'saves token' do
    cookie = 'csrftoken=123e45'
    subject.instance_variable_set('@cookie', cookie)
    expect(subject.send(:csrftoken)).to eq '123e45'
  end
end
