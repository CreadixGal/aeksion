require 'rails_helper'

RSpec.describe 'Movements', type: :request do
  subject { create(:movement) }

  before { sign_in build(:user) }

  describe 'GET /movements' do
    it 'returns http success' do
      get movements_path
      expect(response).to have_http_status(:success)
    end

    it 'renders a list of movements' do
      get movements_path
      expect(response.body).to include('Movimientos')
    end

    it 'renders total count of created movements' do
      get movements_path
      expect(response.body).to include("Total: #{Movement.count}")
    end

    it 'renders a turbo frame with id movements' do
      get movements_path
      expect(response.body).to include('<turbo-frame class="w-full" id="movements">')
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get movement_path(subject)
      expect(response).to have_http_status(:success)
    end

    it 'renders a movement' do
      get movement_path(subject)
      expect(response.body).to include(subject.id)
    end
  end
end