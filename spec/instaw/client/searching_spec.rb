require 'spec_helper'

describe Instaw::Client::Searching do
  subject { Instaw::Client.new }

  let(:rank_token) { rand }
  let(:query) { 'search_query' }

  before do
    allow(subject).to receive(:rank_token).and_return(rank_token)
  end
  describe '#search(query)' do
    it 'calls Request#get' do
      expect(subject).to receive(:get).with(
        '/web/search/topsearch/',
        hash_including(
          context: 'blended',
          query: query,
          rank_token: rank_token
        ),
        { referer: Instaw.endpoint + '/' }
      )
      subject.send(:search, query)
    end
  end

  describe '#find_locations(query)' do
    let(:locations) { [{'pk' => '000000'}] }
    let(:response_hash) { {'places' => locations} }

    it 'calls #search(query)' do
      expect(subject).to receive(:search).with(query).and_return(response_hash)
      subject.find_locations(query)
    end

    it 'returns places' do
      allow(subject).to receive(:search).and_return(response_hash)
      expect(subject.find_locations(query)).to match_array(locations)
    end
  end

  describe '#find_hashtags(query)' do
    let(:hashtags) { [{'pk' => '000000'}] }
    let(:response_hash) { {'hashtags' => hashtags} }

    it 'calls #search(query)' do
      expect(subject).to receive(:search).with(query).and_return(response_hash)
      subject.find_hashtags(query)
    end

    it 'returns hashtags' do
      allow(subject).to receive(:search).and_return(response_hash)
      expect(subject.find_hashtags(query)).to match_array(hashtags)
    end
  end
end