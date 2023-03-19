class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.includes(image_attachment: :blob)
                       .references(:image_attachment).all
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
    Rails.logger.info product_params
    create_or_destroy_variant(@product, product_params) if product_params[:variants_attributes].present?

    respond_to do |format|

        format.html { redirect_to products_path, success: 'Product was successfully updated.' }
        format.turbo_stream { flash.now[:success] = 'Product was successfully updated.' }
      # else
      #   format.html { redirect_to products_path, status: :unprocessable_entity }
      #   format.turbo_stream { flash.now[:error] = @product.errors.full_messages.join(', ') }
      # end
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
    params.require(:product)
          .permit(:name, :kind, :image, :stock,
                  variants_attributes: %i[id name zone_id _destroy price]).compact_blank
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def create_or_destroy_variant(product, product_params)
    product_params[:variants_attributes].each do |_, variant|
      next if variant[:zone_id].blank? || variant[:price].blank?

      if variant[:_destroy].eql?('1')
        delete_variant(product, variant[:id])
      else
        existing_variant = product.variants.find_by(id: variant[:id])
        if existing_variant.present?
          existing_variant.zone_id = variant[:zone_id]
          existing_variant.price.quantity = variant[:price]
          existing_variant.save!
        else
          new_variant = product.variants.create!(
            code: "#{product.name}-#{rand(0..99)}",
            zone_id: variant[:zone_id]
          )
          new_variant.price = Price.new quantity: variant[:price]
          new_variant.save!
        end
      end
    end
  end

  def delete_variant(product, id)
    return if id.blank?

    product.variants.find(id).destroy!
  end
end
