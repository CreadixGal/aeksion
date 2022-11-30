require 'rails_helper'

RSpec.describe 'Api::V1::Customers', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/api/v1/customers'
      expect(response).to have_http_status(:success)
    end
  end
end
