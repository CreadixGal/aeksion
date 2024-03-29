class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  add_breadcrumb 'Productos', ''

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
    @product = Product.new(product_params.except(:variants_attributes))

    respond_to do |format|
      if @product.save
        create_or_destroy_variant(product_params) if product_params[:variants_attributes].present?
        format.html { redirect_to products_path, success: 'Product was successfully created.' }
        format.turbo_stream { flash.now[:success] = 'Product was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    create_or_destroy_variant(product_params) if product_params[:variants_attributes].present?

    respond_to do |format|
      if @product.update(product_params.except(:variants_attributes))
        format.html { redirect_to products_path, success: 'Product was successfully updated.' }
        format.turbo_stream { flash.now[:success] = 'Product was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
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
    params.require(:product)
          .permit(:name, :kind, :image, :stock,
                  variants_attributes: %i[id name zone_id _destroy price]).compact_blank
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def create_or_destroy_variant(product_params)
    product_params[:variants_attributes].each do |_, variant|
      next if variant[:zone_id].blank? || variant[:price].blank?

      if variant[:_destroy].eql?('1')
        type, message = delete_variant(variant[:id])
      elsif variant[:id].present?
        type, message = update_variant(variant)
      else
        type, message = create_variant(variant)
      end

      flash.now[type] = message
    end
  end

  def create_variant(params)
    zone = Zone.find_by(id: params[:zone_id])
    variant = @product.variants.create!(
      code: "#{@product.name}-#{zone.name.downcase.tr('^a-z', '').slice(0, 2)}",
      zone_id: zone.id
    )
    variant.price = Price.new quantity: params[:price]
    variant.save!
    [:success, 'Variant was successfully created.']
  rescue ActiveRecord::RecordInvalid
    [:error, 'Variant was not created.']
  end

  def update_variant(params)
    variant = @product.variants.find_by(id: params[:id])
    variant.zone_id = params[:zone_id]
    price = Price.find(variant.price.id)
    price.quantity = params[:price]
    price.save!
    variant.save!
    [:success, 'Variant was successfully updated.']
  rescue ActiveRecord::RecordInvalid
    [:error, 'Variant was not updated.']
  end

  def delete_variant(id)
    return if id.blank?

    @product.variants.find_by(id:).destroy!
    [:success, 'Variant was successfully destroyed.']
  end
end
