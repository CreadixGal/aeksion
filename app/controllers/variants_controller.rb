class VariantsController < ApplicationController
  def index
    if params[:zone_id].present?
      variants = Variant.where(zone_id: params[:zone_id])
    else
      variants = Variant.all
    end

    # get only the variants that have a price
    variants = variants.where.not(price: nil)

    render json: variants.select(:id, :code, :product_id).map { |variant| { id: variant.id, code: variant.code, product_id: variant.product.id} }
  end
end
