require 'rails_helper'

RSpec.describe "/users", type: :request do
  subject(:user) { build :user }
  let(:valid_headers) {
    {}
  }

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post users_url,
               params: { user: attributes_for(:user) }, headers: valid_headers, as: :json
        }.to change(User, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        post users_url,
             params: { user: attributes_for(:user) }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post users_url,
               params: { user: attributes_for(:user, email: '') }, as: :json
        }.to change(User, :count).by(0)
      end

      it "renders a JSON response with errors for the new user" do
        post users_url,
             params: { user: attributes_for(:user, email: '') }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested user" do
        user = create(:user)
        patch user_url(user),
              params: { user: attributes_for(:user) }, headers: valid_headers, as: :json
        user.reload
      end

      it "renders a JSON response with the user" do
        user = create(:user)
        patch user_url(user),
              params: { user: attributes_for(:user) }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the user" do
        user = create(:user)
        patch user_url(user),
              params: { user: attributes_for(:user, email: '') }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end
end
