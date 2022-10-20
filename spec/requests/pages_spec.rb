require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /dashboard' do
    it 'returns http success' do
      get dashboard_path
      expect(response).to have_http_status(:success)
    end
  end
end
