require 'spec_helper'

describe Instaw do
  it 'have a Client' do
    expect(Instaw.constants).to include(:Client)
  end
end