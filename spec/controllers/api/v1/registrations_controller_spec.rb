require 'rails_helper'

describe Api::V1::RegistrationsController, type: :controller do
  describe '/client_signup' do
    let(:valid_params) do
      {
        email: 'tt@tt.tt',
        password: '123123',
        password_confirmation: '123123',
        phone: '89992948080',
        first_name: 'Daniil',
        last_name: 'Daniil'
      }
    end
    let(:invalid_params) do
      {
        email: 'ee',
        phone: 'afk'
      }
    end

    it 'succesfully creates user when all params are valid' do
      post :client_signup, params: valid_params

      res = JSON.parse(response.body)

      expect(res['user']).to be_a Hash
      expect(User.count).to eq 1
    end

    it 'returns errors when at least one params is invalid' do
      post :client_signup, params: invalid_params

      res = JSON.parse(response.body)

      expect(response.status).to eq 400
      expect(res['errors']).to be_a Hash
    end
  end
end
