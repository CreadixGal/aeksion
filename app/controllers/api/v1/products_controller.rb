# rubocop:disable Rails/SkipsModelValidations

class Api::V1::ProductsController < Api::V1::BaseController
  before_action :set_product, only: %i[show update destroy]
  def index
    products = Product.all
    json_render(products)
  end

  def show
    json_render(@product)
  end

  def create
    product = Product.create!(product_params)
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

  def update
    @product.update!(product_params)
    json_render(@product)
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

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:products).permit(:code, :kind, :name, :price, :stock)
  end
end

# rubocop:enable Rails/SkipsModelValidations
