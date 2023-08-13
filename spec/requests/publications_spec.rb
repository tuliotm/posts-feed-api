require 'rails_helper'

RSpec.describe "/publications", type: :request do
  subject(:publication) { build :publication }
  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response with a valid JWT token" do
      publication = create(:publication)
      token = JWT.encode({ user_id: publication.user_id }, 'secret')

      get publications_url, headers: { "Authorization" => token }, as: :json
      expect(response).to be_successful

      expect(JSON.parse(response.body)).to have_key("publications")
    end

    it "renders a successful response with a valid JWT token and pagination" do
      publication = create(:publication)
      token = JWT.encode({ user_id: publication.user_id }, 'secret')

      get publications_url(page: 1, per_page: 10), headers: { "Authorization" => "Bearer #{token}" }, as: :json

      expect(response).to be_successful

      expect(JSON.parse(response.body)).to have_key("publications")
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      publication = create(:publication)
      token = JWT.encode({ user_id: publication.user_id }, 'secret')

      get publication_url(publication), headers: { "Authorization" => token }, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Publication" do
        publication = create(:publication)
        token = JWT.encode({ user_id: publication.user_id }, 'secret')
        expect {
          post publications_url,
               params: { publication: publication }, headers: { "Authorization" => token }, as: :json
        }.to change(Publication, :count).by(1)
      end

      it 'renders file attributes when file is attached' do
        publication = create(:publication)
  
        serialized_publication = PublicationSerializer.new(publication).serializable_hash
        serialized_file = serialized_publication[:file]
  
        expect(serialized_file).to eq(
          {
            filename: 'empty_file.txt',
            content_type: 'text/plain',
            byte_size: 0
          }
        )
      end

      it "renders a JSON response with the new publication" do
        publication = create(:publication)
        token = JWT.encode({ user_id: publication.user_id }, 'secret')
        post publications_url,
             params: { publication: publication }, headers: { "Authorization" => token }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Publication" do
        publication = create(:publication)
        token = JWT.encode({ user_id: publication.user_id }, 'secret')
        expect {
          post publications_url,
               params: { publication: attributes_for(:publication, title: '') }, headers: { "Authorization" => token }, as: :json
        }.to change(Publication, :count).by(0)
      end

      it "renders a JSON response with errors for the new publication" do
        post publications_url,
             params: { publication: attributes_for(:publication) }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested publication" do
        publication = create(:publication)
        token = JWT.encode({ user_id: publication.user_id }, 'secret')
        patch publication_url(publication),
              params: { publication: attributes_for(:publication) }, headers: { "Authorization" => token } , as: :json
        publication.reload
      end

      it "renders a JSON response with the publication" do
        publication = create(:publication)
        token = JWT.encode({ user_id: publication.user_id }, 'secret')
        patch publication_url(publication),
              params: { publication: attributes_for(:publication) }, headers: { "Authorization" => token }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the publication" do
        publication = create(:publication)
        token = JWT.encode({ user_id: publication.user_id }, 'secret')
        patch publication_url(publication),
              params: { publication: attributes_for(:publication, title: "") }, headers: { "Authorization" => token }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

      it "does not authorized to update a Publication" do
        publication = create(:publication)
        token = JWT.encode({ user_id: publication.user_id }, 'secret')
        antoher_user = create(:user)
        another_token = JWT.encode({ user_id: antoher_user.id }, 'secret')

        patch publication_url(publication),
             params: { publication: attributes_for(:publication) }, headers: { "Authorization" => another_token }, as: :json
        expect(response).to have_http_status(:forbidden)
      end
  end

  describe "DELETE /destroy" do
    it "destroys the requested publication" do
      publication = create(:publication)
      token = JWT.encode({ user_id: publication.user_id }, 'secret')
      expect {
        delete publication_url(publication), headers: { "Authorization" => token }, as: :json
      }.to change(Publication, :count).by(-1)
    end

    it "renders an error message and returns forbidden status" do
      publication = create(:publication)
      another_user = create(:user)
      token = JWT.encode({ user_id: another_user.id }, 'secret')
      expect {
        delete publication_url(publication), headers: { "Authorization" => "Bearer #{token}" }, as: :json
      }.not_to change(Publication, :count)

      expect(response).to have_http_status(:forbidden)
      expect(JSON.parse(response.body)["error"]).to eq("Você não tem permissão para excluir esta publicação")
    end 
  end
end
