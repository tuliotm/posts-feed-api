require 'rails_helper'

RSpec.describe 'JsonHelpers', type: :request do
  include Request::JsonHelpers

  describe '#json_response' do
    it 'parses the JSON response' do
      response_body = { key: 'value' }.to_json
      allow(response).to receive(:body).and_return(response_body)

      parsed_response = json_response
      expect(parsed_response).to eq({ key: 'value' })
    end
  end
end
