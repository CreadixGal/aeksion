class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.all.order(created_at: :desc)
    @pagy, @products = pagy(@products, items: 10)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to products_path, success: 'Product was successfully created.' }
        format.turbo_stream { flash.now[:success] = 'Product was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to products_path, success: 'Product was successfully updated.' }
        format.turbo_stream { flash.now[:success] = 'Product was successfully updated.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, alert: 'Product was successfully destroyed.' }
      format.turbo_stream { flash.now[:alert] = 'Product was successfully destroyed.' }
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :code, :kind, :image, :price, :stock)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
