require 'rails_helper'

RSpec.describe 'Rates' do
  before { sign_in build(:user) }

  let(:customer) { create(:customer) }
  let(:zone) { create(:zone) }
  let(:rate) { create(:rate, customer:, zone:, kind: 'delivery') }

  describe 'GET /rates' do
    it 'returns a list of pickup rates' do
      get rates_path(kind: 'pickup')
      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of delivery rates' do
      get rates_path(kind: 'delivery')
      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of return rates' do
      get rates_path(kind: 'return')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get rate_path(rate)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /rates/new' do
    it 'renders a successful response' do
      get new_rate_path
      expect(response).to have_http_status(:ok)
    end
  end
end
