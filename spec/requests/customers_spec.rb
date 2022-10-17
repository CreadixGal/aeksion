require 'rails_helper'

RSpec.describe '/customers', type: :request do
  let(:valid_attributes) { { name: Faker::Company.name } }

  let(:invalid_attributes) { { name: nil } }

  describe 'GET /index' do
    it 'renders a successful response' do
      Customer.create! valid_attributes
      get customers_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      customer = Customer.create! valid_attributes
      get customer_url(customer)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_customer_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      customer = Customer.create! valid_attributes
      get edit_customer_url(customer)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Customer' do
        expect do
          post customers_url, params: { customer: valid_attributes }
        end.to change(Customer, :count).by(1)
      end

      it 'redirects to the created customer' do
        post customers_url, params: { customer: valid_attributes }
        expect(response).to redirect_to(customer_url(Customer.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Customer' do
        expect do
          post customers_url, params: { customer: invalid_attributes }
        end.not_to change(Customer, :count)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post customers_url, params: { customer: invalid_attributes }
        expect(subject).to render_template(:new)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: Faker::Company.name }
      end

      it 'updates the requested customer' do
        customer = Customer.create! valid_attributes
        patch customer_url(customer), params: { customer: new_attributes }
        customer.reload
        expect(customer.name).to eq(new_attributes[:name])
      end

      it 'redirects to the customer' do
        customer = Customer.create! valid_attributes
        patch customer_url(customer), params: { customer: new_attributes }
        customer.reload
        expect(response).to redirect_to(customer_url(customer))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        customer = Customer.create! valid_attributes
        patch customer_url(customer), params: { customer: invalid_attributes }
        expect(subject).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested customer' do
      customer = Customer.create! valid_attributes
      expect do
        delete customer_url(customer)
      end.to change(Customer, :count).by(-1)
    end

    it 'redirects to the customers list' do
      customer = Customer.create! valid_attributes
      delete customer_url(customer)
      expect(response).to redirect_to(customers_url)
    end
  end
end
