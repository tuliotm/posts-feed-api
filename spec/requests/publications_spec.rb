require 'rails_helper'

RSpec.describe "/publications", type: :request do
  subject(:publication) { build :publication }
  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      publication = create(:publication)
      get publications_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      publication = create(:publication)
      get publication_url(publication), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Publication" do
        publication = create(:publication)
        expect {
          post publications_url,
               params: { publication: publication }, headers: valid_headers, as: :json
        }.to change(Publication, :count).by(1)
      end

      it "renders a JSON response with the new publication" do
        publication = create(:publication)
        post publications_url,
             params: { publication: publication }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Publication" do
        expect {
          post publications_url,
               params: { publication: attributes_for(:publication) }, as: :json
        }.to change(Publication, :count).by(0)
      end

      it "renders a JSON response with errors for the new publication" do
        post publications_url,
             params: { publication: attributes_for(:publication) }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested publication" do
        publication = create(:publication)
        patch publication_url(publication),
              params: { publication: attributes_for(:publication) }, headers: valid_headers, as: :json
        publication.reload
      end

      it "renders a JSON response with the publication" do
        publication = create(:publication)
        patch publication_url(publication),
              params: { publication: attributes_for(:publication) }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the publication" do
        publication = create(:publication)
        patch publication_url(publication),
              params: { publication: attributes_for(:publication, user_id: "") }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested publication" do
      publication = create(:publication)
      expect {
        delete publication_url(publication), headers: valid_headers, as: :json
      }.to change(Publication, :count).by(-1)
    end
  end
end
