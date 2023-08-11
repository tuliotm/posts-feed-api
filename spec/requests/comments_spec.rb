require 'rails_helper'

RSpec.describe "/comments", type: :request do
  subject(:comment) { build :comment }
  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      comment = create(:comment)
      get comments_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      comment = create(:comment)
      get comment_url(comment), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Comment" do
        comment = create(:comment)
        expect {
          post comments_url,
               params: { comment: comment }, headers: valid_headers, as: :json
        }.to change(Comment, :count).by(1)
      end

      it "renders a JSON response with the new comment" do
        comment = create(:comment)
        post comments_url,
             params: { comment: comment }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Comment" do
        expect {
          post comments_url,
               params: { comment: attributes_for(:publication) }, as: :json
        }.to change(Comment, :count).by(0)
      end

      it "renders a JSON response with errors for the new comment" do
        post comments_url,
             params: { comment: attributes_for(:publication) }, headers: valid_headers, as: :json
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
        patch comment_url(comment),
              params: { comment: attributes_for(:comment) }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the comment" do
        comment = create(:comment)
        patch comment_url(comment),
              params: { comment: attributes_for(:comment, commentable_type: "") }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested comment" do
      comment = create(:comment)
      expect {
        delete comment_url(comment), headers: valid_headers, as: :json
      }.to change(Comment, :count).by(-1)
    end
  end
end
