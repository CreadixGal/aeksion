# rubocop:disable Rails/SkipsModelValidations

class Api::V1::ProductsController < Api::V1::BaseController
  def index
    products = Product.all
    json_render(products)
  end

  def show
    product = Product.find(params[:id])
    json_render(product)
  end

  def create
    code = params[:products][0][:code]
    kind = params[:products][0][:kind]
    name = params[:products][0][:name]
    price = params[:products][0][:price]
    stock = params[:products][0][:stock]
    product = Product.create(code: code, kind: kind, name: name, price: price, stock: stock)
    json_render(product)
  end

  def create_bulk
    products = params[:products].map do |product|
      {
        code: product[:code],
        kind: product[:kind],
        name: product[:name],
        price: product[:price],
        stock: product[:stock]
      }
    end

    Product.upsert_all(products)

    json_render(products)
  end

  def update_bulk
    products = params[:products].map do |product|
      {
        id: product[:id],
        code: product[:code],
        kind: product[:kind],
        name: product[:name],
        price: product[:price],
        stock: product[:stock]
      }
    end

    Product.upsert_all(products, unique_by: :id)

    json_render(products)
  end

  def destroy
    product = Product.find(params[:products][0][:id])
    product.rates.destroy! if product.rates.present?
    product.destroy!
  end
end

# rubocop:enable Rails/SkipsModelValidations
