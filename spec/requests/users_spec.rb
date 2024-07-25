require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /users' do
    let(:user_attributes) { attributes_for(:user) }

    let(:valid_attributes) do
      {
        user: {
          full_name: user_attributes[:full_name],
          email: user_attributes[:email],
          password: user_attributes[:password],
          password_confirmation: user_attributes[:password_confirmation]
        }
      }
    end

    let(:invalid_attributes) do
      {
        user: {
          full_name: '',
          email: 'invalid',
          password: 'short',
          password_confirmation: 'short'
        }
      }
    end

    it 'creates a new user with valid attributes' do
      expect {
        post '/users', params: valid_attributes
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['message']).to eq('Account created successfully!')
    end

    it 'does not create a new user with invalid attributes' do
      expect {
        post '/users', params: invalid_attributes
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['message']).to eq('Account creation failed')
    end
  end

  describe 'POST login' do
    let!(:user) { create(:user) }

    let(:valid_credentials) do
      {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    let(:invalid_credentials) do
      {
        user: {
          email: user.email,
          password: 'wrongpassword'
        }
      }
    end

    it 'logs in with valid credentials' do
      post '/login', params: valid_credentials

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key('token')
    end

    it 'does not log in with invalid credentials' do
      post '/login', params: invalid_credentials

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
    end
  end
end
