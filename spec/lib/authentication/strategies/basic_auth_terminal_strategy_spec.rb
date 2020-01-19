require 'rails_helper'

describe Authentication::Strategies::BasicAuthTerminalStrategy do
  describe '#valid?' do
    context 'when authorization header is valid' do
      it 'returns true' do
        env = basic_auth(1, 'password')
        strategy = described_class.new(env, :terminal)

        expect(strategy).to be_valid
      end
    end

    context 'when authorization header isn\'t valid' do
      it 'returns false' do
        env = {}
        strategy = described_class.new(env, :terminal)

        expect(strategy).not_to be_valid
      end
    end
  end

  describe '#authenticate!' do
    context 'when credentials are invalid' do
      let(:env) { basic_auth(1, 'password') }
      let(:strategy) { described_class.new(env, :terminal) }

      before { strategy.authenticate! }

      it('fails authentication') { expect(strategy.result).to eq(:failure) }
    end

    context 'when credentials are valid' do
      let(:env) { basic_auth(terminal.id, 'password') }
      let(:strategy) { described_class.new(env, :terminal) }
      let(:terminal) { build(:terminal) }

      before { terminal.save; strategy.authenticate! }

      it('successes authentication') { expect(strategy.result).to eq(:success) }
      it('assigns current_terminal correctly') { expect(strategy.user).to eq(terminal) }
    end
  end
end
