class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.all
    @pagy, @products = pagy(@products, items: 10)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      flash.now[:alert] = 'Product was not created.'
      render 'new'
    end
  end

  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)
      redirect_to @product
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy!

    redirect_to products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :code, :kind, :image, :price, :stock)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
