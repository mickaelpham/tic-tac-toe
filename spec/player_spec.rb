require_relative '../lib/player'

RSpec.describe Player do
  let(:instance) { described_class.new(name, token) }
  let(:name)     { nil }
  let(:token)    { nil }

  describe '#name' do
    let(:name) { 'Mickael' }
    specify { expect(instance.name).to eq(name) }
  end

  describe '#token' do
    let(:token) { 'X' }
    specify { expect(instance.token).to eq(token) }
  end
end
