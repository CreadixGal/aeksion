class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pagy::Backend

  add_breadcrumb 'Inicio', :root_path
  add_flash_types :success, :error, :alert, :info, :notice

  before_action :set_pending_issue_count

  private

  def set_pending_issue_count
    return 0 unless user_signed_in?

    @pending_issues = IssueTracker.pending_count
  end
end
