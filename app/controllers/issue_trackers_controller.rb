class IssueTrackersController < ApplicationController
  before_action :set_issue_tracker, only: %i[show]

  def index; end
  def show; end
  def new; end

  def create
    @issue = IssueTracker.new(issue_tracker_params)
    if @issue.save
      redirect_to @issue, success: 'Issue tracker was successfully created.'
    else
      render :new
    end
  end

  private

  def set_issue_tracker
    @issue = IssueTracker.find(params[:id])
  end

  def issue_tracker_params
    params.require(:issue_tracker).permit(:title, :description, images: [])
  end
end
