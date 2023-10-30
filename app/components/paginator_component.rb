class PaginatorComponent < ViewComponent::Base
  attr_accessor :path, :current_items, :path_params

  def initialize(path:, current_items:, path_params: {})
    super()
    @path = path
    @current_items = current_items.presence || 10
    @path_params = path_params
  end

  def get_path_params_and_merge_new_one(items)
    merged_params = @path_params.merge(items:)
    @path.call(merged_params)
  end
end
