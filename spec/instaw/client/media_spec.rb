require 'spec_helper'

describe Instaw::Client::Media do
  subject { Instaw::Client.new }

  let(:media) { [{'code' => 'samplecode'}] }
  let(:search_hash) {{
        'media' => {
          'nodes' => media
        },
        'top_posts' => {
          'nodes' => media
        }
    }}

  describe '#search_media_by_hashtag(hashtag)' do

    let(:hashtag) { 'sampletag' }
    let(:response_hash) {{'tag' => search_hash}}

    it 'calls Request#get' do
      expect(subject).to receive(:get).with(
        "/explore/tags/#{hashtag}/",
        hash_including(
          __a: 1
        ),
        { referer: Instaw.endpoint + "/explore/tags/#{hashtag}/" }
      ).and_return(:response_hash)
      subject.send(:search_media_by_hashtag, hashtag)
    end

    it 'returns "tag"' do
      allow(subject).to receive(:get).and_return(response_hash)
      expect(subject.send(:search_media_by_hashtag, hashtag)).to eq response_hash['tag']
    end
  end

  describe '#search_media_by_location(location)' do

    let(:location) { 'samplelocation' }
    let(:response_hash) {{'location' => search_hash}}

    it 'calls Request#get' do
      expect(subject).to receive(:get).with(
        "/explore/locations/#{location}/",
        hash_including(
          __a: 1
        ),
        { referer: Instaw.endpoint + "/explore/locations/#{location}/" }
      ).and_return(:response_hash)
      subject.send(:search_media_by_location, location)
    end

    it 'returns "location"' do
      allow(subject).to receive(:get).and_return(response_hash)
      expect(subject.send(:search_media_by_location, location)).to eq response_hash['location']
    end
  end

  describe '#search_media' do

    [
      {desc: 'all arguments specified', args: {hashtag: 'tag', location: 'location'}},
      {desc: 'all agruments not specified', args: {hashtag: nil, location: nil}}
    ].each do |con|
      context "when #{con[:desc]}" do
        it 'raises ArgumentError' do
          expect {
            subject.send(:search_media, con[:args])
          }.to raise_error(ArgumentError)
        end
      end
    end

    [
      {desc: 'hashtag', args: {hashtag: 'tag'}},
      {desc: 'location', args: {location: 'location'}}
    ].each do |con|
      context "when specified #{con[:desc]}" do
        it "calls search_media_by_#{con[:desc]}" do
          expect(subject).to receive("search_media_by_#{con[:desc]}".to_sym).and_return(search_hash)
          subject.send(:search_media, con[:args])
        end

        it 'returns search_hash' do
          allow(subject).to receive("search_media_by_#{con[:desc]}".to_sym).and_return(search_hash)
          expect(subject.send(:search_media, con[:args])).to eq search_hash
        end
      end
    end
  end

  describe '#popular_media(args)' do
    let(:args) {{ hashtag: 'tag', location: nil }}

    it 'calls search_media(args)' do
      expect(subject).to receive(:search_media).with(args).and_return(search_hash)
      subject.popular_media(args)
    end

    it 'returns top_posts.nodes' do
      allow(subject).to receive(:search_media).and_return(search_hash)
      expect(subject.popular_media(args)).to eq search_hash['top_posts']['nodes']
    end
  end

  describe '#recent_media(args)' do
    let(:args) {{ hashtag: 'tag', location: nil }}

    it 'calls search_media(args)' do
      expect(subject).to receive(:search_media).with(args).and_return(search_hash)
      subject.recent_media(args)
    end

    it 'returns media.nodes' do
      allow(subject).to receive(:search_media).and_return(search_hash)
      expect(subject.recent_media(args)).to eq search_hash['media']['nodes']
    end
  end
end