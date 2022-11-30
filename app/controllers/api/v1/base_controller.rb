class Api::V1::BaseController < ActionController::API
  def json_render(object, status: :ok)
    render json: object, status:
  end

  rescue_from ActiveRecord::RecordInvalid do |err|
    json_render({ message: err.message }, status: :unprocessable_entity)
  end

  rescue_from ActiveRecord::RecordNotFound do |err|
    json_render({ message: err.message }, status: :not_found)
  end

  rescue_from StandardError do |err|
    json_render({ message: err.message }, status: :unprocessable_entity)
  end

  rescue_from ActionController::ParameterMissing do |err|
    json_render({ error: "Required parameter missing: #{err.param}" }, status: :bad_request)
  end

  rescue_from ArgumentError do |err|
    json_render({ error: err.message }, status: :bad_request)
  end
end
