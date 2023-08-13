require 'rails_helper'

RSpec.describe "/comments", type: :request do
  subject(:comment) { build :comment }
  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      comment = create(:comment)
      token = JWT.encode({ user_id: comment.user_id }, 'secret')
      get comments_url, headers: { "Authorization" => token }, as: :json
      expect(response).to be_successful
    end

    it "renders a successful response with a valid JWT token and pagination" do
      comment = create(:comment)
      token = JWT.encode({ user_id: comment.user_id }, 'secret')

      get comments_url(page: 1, per_page: 10), headers: { "Authorization" => "Bearer #{token}" }, as: :json

      expect(response).to be_successful

      expect(JSON.parse(response.body)).to have_key("comments")
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      comment = create(:comment)
      token = JWT.encode({ user_id: comment.user_id }, 'secret')
      get comment_url(comment), headers: { "Authorization" => token }, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Comment" do
        comment = create(:comment)
        token = JWT.encode({ user_id: comment.user_id }, 'secret')
        expect {
          post comments_url,
               params: { comment: comment }, headers: { "Authorization" => token }, as: :json
        }.to change(Comment, :count).by(1)
      end

      it "renders a JSON response with the new comment" do
        comment = create(:comment)
        token = JWT.encode({ user_id: comment.user_id }, 'secret')
        post comments_url,
             params: { comment: comment }, headers: { "Authorization" => token }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Comment" do
        expect {
          post comments_url,
               params: { comment: attributes_for(:comment) }, as: :json
        }.to change(Comment, :count).by(0)
      end

      it "renders a JSON response with errors for the new comment" do
        publication = create(:publication)
        token = JWT.encode({ user_id: publication.user_id }, 'secret')
        post comments_url,
             params: { comment: attributes_for(:publication) }, headers: { "Authorization" => token }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested comment" do
        comment = create(:comment)
        patch comment_url(comment),
              params: { comment: attributes_for(:comment) }, headers: valid_headers, as: :json
        comment.reload
      end

      it "renders a JSON response with the comment" do
        comment = create(:comment)
        token = JWT.encode({ user_id: comment.user_id }, 'secret')
        patch comment_url(comment),
              params: { comment: attributes_for(:comment) }, headers: { "Authorization" => token }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the comment" do
        comment = create(:comment)
        token = JWT.encode({ user_id: comment.user_id }, 'secret')
        patch comment_url(comment),
              params: { comment: attributes_for(:comment, commentable_type: "") }, headers: { "Authorization" => token }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end

      it "does not authorized to update a Comment" do
        comment = create(:comment)
        token = JWT.encode({ user_id: comment.user_id }, 'secret')
        antoher_user = create(:user)
        another_token = JWT.encode({ user_id: antoher_user.id }, 'secret')

        patch comment_url(comment),
             params: { comment: attributes_for(:comment) }, headers: { "Authorization" => another_token }, as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested comment" do
      comment = create(:comment)
      token = JWT.encode({ user_id: comment.user_id }, 'secret')
      expect {
        delete comment_url(comment),  headers: { "Authorization" => token }, as: :json
      }.to change(Comment, :count).by(-1)
    end

    it "renders a Forbidden response if user is not authorized to delete the comment" do
      comment = create(:comment)
      unauthorized_user = create(:user)
    
      unauthorized_token = JWT.encode({ user_id: unauthorized_user.id }, 'secret')
    
      expect {
        delete comment_url(comment), headers: { "Authorization" => "Bearer #{unauthorized_token}" }, as: :json
      }.not_to change(Comment, :count)
    
      expect(response).to have_http_status(:forbidden)
    end    
  end
end
