# frozen_string_literal: true

class ListComponent < ViewComponent::Base
  include Turbo::FramesHelper

  renders_many :rows, 'ListComponent::LiComponent'

  attr_reader :headers, :cols, :resources, :select_all

  def initialize(headers:, cols:, resources:, select_all: true)
    super
    @headers = headers
    @cols = cols
    @resources = resources
    @select_all = select_all
  end

  def model_name
    return if resources.empty?

    resources&.first.model_name.param_key
  end

  def style
    style = '[&>*:nth-child(even)]:bg-slate-200 [&>*:hover]:bg-slate-400'
    style = 'bg-red-100 [&>*:nth-child(even)]:bg-red-200 [&>*:hover]:bg-red-400' if params[:active].eql? 'false'
    style
  end
end
