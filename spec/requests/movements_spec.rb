require 'rails_helper'

RSpec.describe 'Movements', type: :request do
  subject { create(:movement) }

  before { sign_in build(:user) }

  let(:valid_attributes) { { rate_id: create(:rate).id, date: Time.zone.now } }

  let(:invalid_attributes) { { rate_id: nil, date: Time.zone.now } }

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

  describe 'GET /new' do
    it 'returns http success' do
      get new_movement_path
      expect(response).to have_http_status(:success)
    end

    it 'renders a new movement form' do
      get new_movement_path
      expect(response.body).to include('form')
    end

    it 'renders a date select on form' do
      get new_movement_path
      expect(response.body).to include('movement[date')
    end
  end

  describe 'POST /create' do
    context 'with valid attributes' do
      it 'increment by 1 the number of movements' do
        expect do
          post movements_path, params: { movement: valid_attributes }
        end.to change(Movement, :count).by(1)
      end

      it 'redirects to the movements index' do
        post movements_path, params: { movement: valid_attributes }
        expect(response).to redirect_to(movements_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not increment the number of movements' do
        expect do
          post movements_path, params: { movement: invalid_attributes }
        end.not_to change(Movement, :count)
      end

      it 'renders a new movement form' do
        post movements_path, params: { movement: invalid_attributes }
        expect(response.body).to include('form')
      end
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get edit_movement_path(subject)
      expect(response).to have_http_status(:success)
    end

    it 'renders a edit movement form' do
      get edit_movement_path(subject)
      expect(response.body).to include('form')
    end

    it 'renders a date select on form' do
      get edit_movement_path(subject)
      expect(response.body).to include('movement[date')
    end
  end

  describe 'PATCH /update' do
    context 'with valid attributes' do
      date = 5.days.ago
      it 'updates the movement' do
        patch movement_path(subject), params: { movement: { date: } }
        expect(subject.reload.date.strftime('%d%m%y')).to eq(date.strftime('%d%m%y'))
      end

      it 'redirects to the movements index' do
        patch movement_path(subject), params: { movement: { date: } }
        expect(response).to redirect_to(movements_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the requested movement and responds with unprocessable entity' do
        patch movement_path(subject), params: { movement: { rate_id: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders a edit movement form' do
        patch movement_path(subject), params: { movement: invalid_attributes }
        expect(response.body).to include('form')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'decrements by 1 the number of movements' do
      move = create(:movement)

      expect do
        delete movement_path(move)
      end.to change(Movement, :count).by(-1)
    end

    it 'redirects to the movements index' do
      move = create(:movement)

      delete movement_path(move)
      expect(response).to redirect_to(movements_path)
    end
  end
end