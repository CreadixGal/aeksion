class ModalComponent < ViewComponent::Base
  include Turbo::FramesHelper
  attr_reader :title

  def initialize(title:)
    super
    @title = title
  end
end
