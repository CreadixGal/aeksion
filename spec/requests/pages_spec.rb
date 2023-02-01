require 'rails_helper'

RSpec.describe 'Pages' do
  subject { create(:user) }

  before { sign_in subject }

  describe 'GET /index' do
    context 'not logged in' do
      it 'returns http success' do
        sign_out subject
        get root_path
        expect(response).to have_http_status(:success)
      end

      it 'renders login button' do
        sign_out subject
        get root_path
        expect(response.body).to include('Entrar')
      end
    end

    context 'logged in' do
      it 'returns http success' do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it 'renders logout button' do
        get root_path
        expect(response.body).to include('logout')
      end
    end
  end

  describe 'GET /dashboard' do
    it 'returns http success' do
      get dashboard_path
      expect(response).to have_http_status(:success)
    end

    it 'renders charts' do
      get dashboard_path
      expect(response.body).to include('chart')
    end
  end
end
