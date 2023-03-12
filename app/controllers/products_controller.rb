class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.includes(:zone, image_attachment: :blob)
                       .references(:zone, :image_attachment).all
                       .order(created_at: :desc)

    @pagy, @products = pagy(@products)
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
        format.html { redirect_to products_path, status: :unprocessable_entity }
        format.turbo_stream { flash.now[:error] = @product.errors.full_messages.join(', ') }
      end
    rescue ActiveRecord::RangeError
      format.html { redirect_to products_path, status: :unprocessable_entity }
      format.turbo_stream { flash.now[:error] = 'Error al guardar. El formato valido: hasta 5 enteros y 4 decimales' }
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
    params.require(:product).permit(:name, :code, :kind, :zone_id, :image, :price, :stock)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
