require 'rails_helper'

describe Admin::EmployeeCreationForm do
  subject(:form) { described_class.new(options, creator) }

  let(:options) { {} }
  let(:creator) { create(:user) }

  context 'when all valid attributes are passed' do
    context 'when password is present' do
      let(:options) do
        {
          email: 'test@another.com',
          password: '123123123',
          password_confirmation: '123123123',
          gender: 'male',
          first_name: 'First name',
          last_name: 'Last name',
          phone: '89991112233'
        }
      end

      it 'successfully creates employee and sends an email' do
        expect(UserMailer).to receive_message_chain(:delay, :welcome_employee) # rubocop:disable RSpec/MessageChain
        expect(form.save).to be_truthy
        expect(form.user.reset_password_token).not_to be_present
      end
    end

    context 'when password is blank' do
      let(:options) do
        {
          email: 'test@another.com',
          password: '',
          password_confirmation: '',
          gender: 'male',
          first_name: 'First name',
          last_name: 'Last name',
          phone: '89991112233'
        }
      end

      it 'successfully creates employee, sends an email and creates restore token' do
        expect(UserMailer).to receive_message_chain(:delay, :welcome_employee) # rubocop:disable RSpec/MessageChain
        expect(form.save).to be_truthy
        expect(form.user.reset_password_token).to be_present
      end
    end
  end
end
