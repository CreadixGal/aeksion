require 'rails_helper'

RSpec.describe 'Rates', type: :request do
  subject { create(:rate) }

  before { sign_in build(:user) }

  after(:all) { Rate.delete_all }

  let(:valid_attributes) do
    {
      customer_id: create(:customer).id,
      zone_id: create(:zone).id,
      kind: %w[delivery pickup].sample,
      price: 0.5
    }
  end

  let(:invalid_attributes) do
    {
      customer_id: nil,
      zone_id: create(:zone).id,
      kind: %w[delivery pickup].sample,
      price: 0.5
    }
  end

  describe 'GET /index' do
    it 'returns http success' do
      get rates_path
      expect(response).to have_http_status(:success)
    end

    it 'renders a list of rates' do
      get rates_path
      expect(response.body).to include('Tarifas')
    end

    it 'renders a turbo frame with id rates' do
      get rates_path
      expect(response.body).to include('<turbo-frame class="w-full" id="rates">')
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get rate_path(subject)
      expect(response).to have_http_status(:success)
    end

    it 'renders a rate' do
      get rate_path(subject)
      expect(response.body).to include(subject.id)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get new_rate_path
      expect(response).to have_http_status(:success)
    end

    it 'renders a new rate form' do
      get new_rate_path
      expect(response.body).to include('form')
    end

    it 'renders a select with options for customer' do
      customer = create(:customer)
      get new_rate_path
      expect(response.body).to include('id="rate_customer_id"')
      expect(response.body).to include("value=\"#{customer.id}\"")
    end

    it 'renders a select with options for zone' do
      zone = create(:zone)
      get new_rate_path
      expect(response.body).to include('id="rate_zone_id"')
      expect(response.body).to include(zone.name)
      expect(response.body).to include("value=\"#{zone.id}\"")
    end
  end

  describe 'POST /create' do
    context 'with valid attributes' do
      it 'increment by 1 the number of rates' do
        expect do
          post rates_path, params: { rate: valid_attributes }
        end.to change(Rate, :count).by(1)
      end

      it 'redirects to the created rate' do
        post rates_path, params: { rate: valid_attributes }
        expect(response).to redirect_to(rates_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new Rate and responds with unprocessble entity' do
        post rates_path, params: { rate: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders a list of errors' do
        post rates_path, params: { rate: invalid_attributes }
        expect(response.body).to include('div id="error_explanation"')
      end

      it 'renders a error message for customer' do
        post rates_path, params: { rate: invalid_attributes }
        expect(response.body).to include('debe existir')
      end
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get edit_rate_path(subject)
      expect(response).to have_http_status(:success)
    end

    it 'renders a edit rate form' do
      get edit_rate_path(subject)
      expect(response.body).to include('form')
    end

    it 'renders a select with options for customer' do
      get edit_rate_path(subject)
      expect(response.body).to include('id="rate_customer_id"')
    end

    it 'renders a select with options for zone' do
      get edit_rate_path(subject)
      expect(response.body).to include('id="rate_zone_id"')
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates the requested rate' do
        patch rate_path(subject), params: { rate: { price: 0.999 } }
        expect(subject.reload.price).to eq(0.999)
      end

      it 'redirects to the rates path' do
        patch rate_path(subject), params: { rate: { price: 0.999 } }
        expect(response).to redirect_to(rates_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the requested rate and responds with unprocessble entity' do
        patch rate_path(subject), params: { rate: { price: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders a list of errors' do
        patch rate_path(subject), params: { rate: { price: nil } }
        expect(response.body).to include('div id="error_explanation"')
      end

      it 'renders a error message for price' do
        patch rate_path(subject), params: { rate: { price: nil } }
        expect(response.body).to include('no puede estar en blanco')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'decrements by 1 the number of rates' do
      rate = create(:rate)
      expect do
        delete rate_path(rate)
      end.to change(Rate, :count).by(-1)
    end

    it 'redirects to the rates path' do
      rate = create(:rate)
      delete rate_path(rate)
      expect(response).to redirect_to(rates_path)
    end
  end

  describe 'DELETE /multiple_delete' do
    it 'redirects to rates path' do
      delete multiple_delete_rates_path, params: { ids: [] }
      expect(response).to redirect_to(rates_path)
    end

    it 'redirects to the rates index' do
      pending 'Bullet::Notification::UnoptimizedQueryError:
      user: cisco
      DELETE /rates/multiple_delete
      USE eager loading detected
        Rate => [:movements]
        Add to your query: .includes([:movements])'
      Zone.includes([:rates]).destroy_all
      zone1 = create(:zone, name: 'Pontevedra')
      zone2 = create(:zone, name: 'Ourense')
      rates = [create(:rate, zone_id: zone1.id), create(:rate, zone_id: zone2.id)]
      delete multiple_delete_rates_path, params: { rate_ids: [rates.first.id, rates.last.id] }
      expect(response).to redirect_to(rates_path)
    end
  end
end
