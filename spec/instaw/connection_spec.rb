require 'spec_helper'

describe Instaw::Connection do
  subject { Instaw::Client.new }

  describe '#authorized?' do
    context 'when @authorized is true' do
      it 'returns true' do
        subject.instance_variable_set("@authorized", true)
        expect(subject.authorized?).to be true
      end
    end

    context 'when @authorized is false' do
      it 'returns false' do
        subject.instance_variable_set("@authorized", false)
        expect(subject.authorized?).to be false
      end
    end
  end

  describe '#set_connection(authorized:, cookie:)' do
    it 'set @authorized' do
      expect(subject.authorized?).to be false
      subject.set_connection(authorized: true, cookie: 'param=cookie')
      expect(subject.authorized?).to be true
    end

    it 'set cookies' do
      expect(subject.cookie).to be nil
      subject.set_connection(authorized: true, cookie: 'param=cookie')
      expect(subject.cookie).to eq 'param=cookie'
    end
  end
end
