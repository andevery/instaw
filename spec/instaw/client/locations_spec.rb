require 'spec_helper'

describe Instaw::Client::Locations do
  subject { Instaw::Client.new }

  let(:rank_token) { rand }

  before do
    allow(subject).to receive(:rank_token).and_return(rank_token)
  end
  describe '.find_locations' do
    it 'calls Request#get' do
      expect(subject).to receive(:get).with(
        '/web/search/topsearch/',
        hash_including(
          context: 'blended',
          query: 'location_name',
          rank_token: rank_token
        ),
        { referer: Instaw.endpoint + '/' }
      )
      subject.find_locations('location_name')
    end
  end
end