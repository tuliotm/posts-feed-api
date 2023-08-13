# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/users', type: :request do
  subject(:user) { build :user }
  let(:valid_headers) do
    {}
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post users_url,
               params: { user: attributes_for(:user) }, headers: valid_headers, as: :json
        end.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post users_url,
             params: { user: attributes_for(:user) }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post users_url,
               params: { user: attributes_for(:user, email: '') }, as: :json
        end.to change(User, :count).by(0)
      end

      it 'renders a JSON response with errors for the new user' do
        post users_url,
             params: { user: attributes_for(:user, email: '') }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates the requested user' do
        user = create(:user)
        patch user_url(user),
              params: { user: attributes_for(:user) }, headers: valid_headers, as: :json
        user.reload
      end

      it 'renders a JSON response with the user' do
        user = create(:user)
        jwt_payload = { user_id: user.id }
        jwt_token = JWT.encode(jwt_payload, 'secret', 'HS256') # Generate a valid JWT token
        patch user_url(user),
              params: { user: attributes_for(:user) }, headers: valid_headers.merge('Authorization' => "Bearer #{jwt_token}"), as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the user' do
        user = create(:user)
        patch user_url(user),
              params: { user: attributes_for(:user, email: '') }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'POST /login' do
    context 'with valid parameters' do
      it 'logs in the user' do
        user = create(:user)
      
        post '/users/login',
             params: { user: { email: user.email, password: user.password } }, headers: valid_headers, as: :json
      
        expect(response).to have_http_status(200)
      end

      it 'renders a JSON response for user login' do
        user = create(:user)

        post '/users/login',
             params: { user: { email: user.email, password: user.password } }, headers: valid_headers, as: :json

        expect(response).to have_http_status(200)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(response.body).to include(user.email)
      end      
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with login errors' do
        post '/users/login',
             params: { user: { email: 'invalid_email', password: 'invalid_password' } }, headers: valid_headers, as: :json
  
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Usuário ou senha inválidos')
      end
    end    
  end

  describe 'DELETE /logout' do
    it 'logs out the user' do
      delete '/users/logout', headers: valid_headers, as: :json

      expect(response).to have_http_status(:no_content)
    end
  end
end
