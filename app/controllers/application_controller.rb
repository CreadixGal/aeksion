class ApplicationController < ActionController::Base
  include Pagy::Backend
  add_breadcrumb 'Inicio', :root_path
  add_flash_types :success, :error, :alert, :info, :notice
end
