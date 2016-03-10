require 'spec_helper'

describe Instaw::Client::Media do
  describe '#search_media_by_hashtag(hashtag)' do
    subject { Instaw::Client.new }

    let(:hashtag) { 'sampletag' }
    let(:media) { [{'code' => 'samplecode'}] }
    let(:response_hash) {{
      'tag' => {
        'media' => {
          'nodes' => media
        },
        'top_posts' => {
          'nodes' => media
        }
      }
    }}

    it 'calls Request#get' do
      expect(subject).to receive(:get).with(
        "/explore/tags/#{hashtag}/",
        hash_including(
          __a: 1
        ),
        { referer: Instaw.endpoint + "/explore/tags/#{hashtag}/" }
      )
      subject.send(:search_media_by_hashtag, hashtag)
    end
  end
end