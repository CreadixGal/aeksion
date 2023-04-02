require 'rails_helper'

RSpec.describe 'Zones' do
  subject { create(:zone) }

  before { sign_in build(:user) }

  let(:valid_attributes) { { name: Zone::VALID_NAMES.sample } }

  let(:invalid_attributes) { { name: nil } }

  describe 'GET /index' do
    it 'returns http success' do
      get zones_path
      expect(response).to have_http_status(:success)
    end

    it 'renders a list of zones' do
      get zones_path
      expect(response.body).to include('Zonas')
    end

    it 'renders a turbo frame' do
      get zones_path
      expect(response.body).to include('turbo-frame')
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get zone_path(subject)
      expect(response).to have_http_status(:success)
    end

    it 'subject is present' do
      get zone_path(subject.id)
      expect(subject).to be_present
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_zone_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_zone_path(subject)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    it 'creates a new Zone' do
      post zones_path, params: { zone: valid_attributes }
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(zones_path)
      expect(Zone.includes([:customers]).last.name).to eq(valid_attributes[:name])
    end

    it 'does not create a new Zone' do
      post zones_path, params: { zone: invalid_attributes }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'show error message' do
      post zones_path, params: { zone: invalid_attributes }
      expect(response.body).to include('error')
    end

    it 'renders zones new form' do
      post zones_path, params: { zone: invalid_attributes }
      expect(response.body).to include('form')
    end
  end

  describe 'PATCH /update' do
    it 'updates the requested zone' do
      patch zone_path(subject), params: { zone: valid_attributes }
      expect(subject.reload.name).to eq(valid_attributes[:name])
    end

    it 'renders a successful response' do
      patch zone_path(subject), params: { zone: valid_attributes }
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to the zones index' do
      patch zone_path(subject), params: { zone: valid_attributes }
      expect(response).to redirect_to(zones_path)
    end

    context 'with invalid parameters' do
      it 'renders zones edit form' do
        patch zone_path(subject), params: { zone: invalid_attributes }
        expect(response.body).to include('form')
      end

      it 'does not update the requested zone' do
        patch zone_path(subject), params: { zone: invalid_attributes }
        expect(subject.reload.name).not_to eq(invalid_attributes[:name])
      end

      it 'renders error notification' do
        patch zone_path(subject), params: { zone: invalid_attributes }
        expect(response.body).to include('error')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'deleted requested customer' do
      delete zone_path(subject)
      expect { subject.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'renders a successful response' do
      delete zone_path(subject)
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to the zones index' do
      delete zone_path(subject)
      expect(response).to redirect_to(zones_path)
    end
  end

  describe 'DELETE /multiple_delete' do
    it 'redirect to zones path' do
      delete multiple_delete_zones_path, params: { ids: [] }
      expect(response).to redirect_to(zones_path)
    end

    it 'redirects to the zones index' do
      names = %w[A_Coruña Lugo Ourense Pontevedra]
      zone1 = create(:zone, name: names[0])
      names.delete(names[0])
      zone2 = create(:zone, name: names[1])
      delete multiple_delete_zones_path, params: { zone_ids: [zone1.id, zone2.id] }
      expect(response).to redirect_to(zones_path)
    end
  end
end
