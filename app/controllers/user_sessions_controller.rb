class UserSessionsController < Devise::SessionsController
  def create
    super
    flash[:notice] = "Bienvenido, #{current_user.email}!"
  end

  private

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end
end
