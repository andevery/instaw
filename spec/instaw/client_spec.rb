require 'spec_helper'

describe Instaw::Client do
  subject { Instaw::Client.new }

  describe '.authorized?' do

    context 'when @authorized is true' do
      it 'returns true' do
        subject.instance_variable_set("@authorized", true)
        expect(subject.send(:authorized?)).to be true
      end
    end

    context 'when @authorized is false' do
      it 'returns false' do
        subject.instance_variable_set("@authorized", false)
        expect(subject.send(:authorized?)).to be false
      end
    end
  end

  describe '#auth' do
    before do
      allow(subject).to receive(:connect)
      allow(subject).to receive(:post)
      allow(subject).to receive(:csrftoken).and_return('123e45')
    end

    it 'calls connect' do
      expect(subject).to receive(:connect)
      subject.auth('username', 'password')
    end

    it 'calls post' do
      expect(subject).to receive(:post).with(
        '/accounts/login/ajax/',
        {username: 'username', password: 'password'},
        {'referer' => 'https://www.instagram.com/', 'x-csrftoken' => '123e45', 'x-instagram-ajax' => '1'}
      )
      subject.auth('username', 'password')
    end
  end
end