require 'rails_helper'

describe Authentication::Strategies::JwtTokenStrategy do
  describe '#valid?' do
    context 'when authorization header is valid' do
      it 'returns true' do
        env = { 'HTTP_AUTHORIZATION' => 'Bearer TEST' }
        strategy = described_class.new(env, :user)

        expect(strategy).to be_valid
      end
    end

    context 'when authorization header isn\'t valid' do
      it 'returns false' do
        env = {}
        strategy = described_class.new(env, :user)

        expect(strategy).not_to be_valid
      end
    end
  end

  describe '#authenticate!' do
    context 'when token is invalid' do
      let(:env) { { 'HTTP_AUTHORIZATION' => 'Bearer TEST' } }
      let(:strategy) { described_class.new(env, :user) }

      before { strategy.authenticate! }

      it('fails authentication') { expect(strategy.result).to eq(:failure) }
    end

    context 'when token is valid' do
      let(:token) { Authentication::Jwt::Engine.encoded_token(user_id: user.id) }
      let(:env) { { 'HTTP_AUTHORIZATION' => "Bearer #{token}" } }
      let(:strategy) { described_class.new(env, :user) }
      let(:user) { create(:user) }

      before { strategy.authenticate! }

      it('successes authentication') { expect(strategy.result).to eq(:success) }
      it('assigns current_user correctly') { expect(strategy.user).to eq(user) }
    end

    context 'when token is expired' do
      let(:token) { Authentication::Jwt::Engine.encoded_token(user_id: user.id, exp: Time.now.to_i - 1) }
      let(:env) { { 'HTTP_AUTHORIZATION' => "Bearer #{token}" } }
      let(:strategy) { described_class.new(env, :user) }
      let(:user) { create(:user) }

      before { strategy.authenticate! }

      it 'fails auth with message what token is expired' do
        expect(strategy.message).to eq('Token has expired')
        expect(strategy.status).to eq(401)
      end
    end
  end
end
