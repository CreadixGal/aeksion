require 'rails_helper'

RSpec.describe 'Movements', type: :request do
  subject { create(:movement) }

  before { sign_in build(:user) }

  let(:valid_attributes) do
    {
      rate_id: create(:rate).id,
      date: Time.zone.now,
      product_movements_attributes: [
        product_id: create(:product).id,
        quantity: rand(1..80)
      ]
    }
  end

  let(:invalid_attributes) { { rate_id: nil, date: Time.zone.now } }

  let(:out_of_stock) do
    {
      rate_id: create(:rate, kind: 'delivery').id,
      date: Time.zone.now,
      product_movements_attributes: [
        product_id: create(:product, stock: 10).id,
        quantity: 11
      ]
    }
  end

  describe 'GET /movements' do
    it 'returns http success' do
      get movements_path(kind: 'delivery')
      expect(response).to have_http_status(:success)
    end

    it 'renders a tab menu' do
      get movements_path(kind: 'delivery')
      expect(response).to render_template('movements/_tabs')
    end

    it 'renders total count of delivery movements' do
      get movements_path(kind: 'delivery')
      expect(response.body).to include(Movement.delivery.count.to_s)
    end

    it 'renders total count of pickup movements' do
      get movements_path(kind: 'pickup')
      expect(response.body).to include(Movement.pickup.count.to_s)
    end

    it 'renders a delivery movements list' do
      get movements_path(kind: 'delivery')
      expect(response.body).to include('delivery')
    end

    it 'renders a pickup movements list' do
      get movements_path(kind: 'pickup')
      expect(response.body).to include('pickup')
    end

    it 'renders a turbo frame with id movements' do
      get movements_path(kind: 'delivery')
      @movements = Movement.delivery
      if @movements.count.positive?
        expect(response.body).to include('<turbo-frame class="w-full" id="movements">')
      else
        expect(response.body).to include('no data provided')
      end
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

      it 'show error message if stock is not enough' do
        post movements_path, params: { movement: out_of_stock }
        expect(response.body).to include('el stock del producto es insuficiente para crear este movimiento')
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

  describe 'DELETE /multiple_delete' do
    it 'renders no content when no movements selected' do
      delete multiple_delete_movements_path, params: { ids: [] }
      expect(response).to have_http_status(:no_content)
    end

    it 'redirects to the movements index' do
      Zone.destroy_all
      Rate.destroy_all
      zone1 = create(:zone, name: 'Pontevedra')
      zone2 = create(:zone, name: 'Ourense')
      rates = [create(:rate, zone_id: zone1.id), create(:rate, zone_id: zone2.id)]
      movements = [create(:movement, rate_id: rates.first.id), create(:movement, rate_id: rates.last.id)]

      delete multiple_delete_movements_path, params: { movement_ids: [movements.first.id, movements.last.id] }
      expect(response).to redirect_to(movements_path)
    end
  end
end
