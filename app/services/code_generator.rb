class CodeGenerator
  def initialize(resource)
    @resource = resource
    @code = @resource.code
  end

  def validate_code
    duplicate = @resource.class.find_by(code: @resource.code).presence || false
    @resource.code = "#{@code}-dup" if duplicate
    @resource.errors.add(:code, 'is already taken') if duplicate
  end

  def run_code
    return unless @resource.is_a? Movement

    data = delivery_code if @resource.rate.delivery?
    data = pickup_code   if @resource.rate.pickup?
    data = 0 if data.nil?
    @resource.code = generate_code(data)
  end

  # rubocop:disable Lint/SafeNavigationChain
  def delivery_code
    @resource.delivery&.order(created_at: :asc).last&.code
  end

  def pickup_code
    @resource.pickup&.order(created_at: :asc).last&.code
  end
  # rubocop:enable Lint/SafeNavigationChain

  def generate_code(last_code)
    rate_code = @resource.rate.kind.slice(0..1).upcase
    year = Time.zone.now.year.to_s.last(2)
    increment = last_code.to_s.slice(5, 7).to_i + 1
    "#{rate_code}#{year}-#{increment.to_s.rjust(7, '0')}"
  end
end
