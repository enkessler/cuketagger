require "#{File.dirname(__FILE__)}/spec_helper"


describe 'Tagger, Unit', :unit_test => true do

  clazz = CukeTagger::Tagger

  let(:tagger) { clazz.new }


  it 'can tag feature files' do
    expect(tagger).to respond_to(:execute)
  end

  it 'tags based on CLI style arguments' do
    expect(tagger.method(:execute).arity).to eq(1)
  end

  it 'can tag feature files without being instantiated' do
    expect(clazz).to respond_to(:execute)
  end

end
