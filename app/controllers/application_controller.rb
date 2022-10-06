class ApplicationController < ActionController::Base
  add_breadcrumb 'Inicio', :root_path
  add_flash_types :success, :error, :alert, :info, :notice
end
