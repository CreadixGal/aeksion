class IssueTrackersController < ApplicationController
  before_action :set_issue_tracker, only: %i[show edit update]

  def index
    @issues = IssueTracker.ordered
    @pagy, @issues = pagy(@issues, items: 10)
  end

  def show
    @issue.viewed! if @issue.pending?
    @comments = @issue.comments.includes(:user)
  end

  def new
    @issue = IssueTracker.new
  end

  def edit; end

  def create
    comment_params = issue_tracker_params[:comment].compact_blank
    issue_params = issue_tracker_params.except(:comment)
    # render plain: issue.inspect

    @issue = current_user.issue_trackers.new(issue_params)
    @issue.comments.build(comment_params)
    if @issue.save
      redirect_to issue_trackers_path, success: 'Issue tracker was successfully created.'
    else
      render :new
    end
  end

  def update
    @comment = @issue.comments.new(issue_tracker_params[:comment])
    if @comment.save
      redirect_to issue_trackers_path, success: 'Issue tracker was successfully updated.'
    else
      redirect_to @issue, danger: 'Comment was not created.'
    end
  end

  private

  def set_issue_tracker
    @issue = IssueTracker.find(params[:id])
  end

  def issue_tracker_params
    params.require(:issue_tracker)
          .permit(
            :title,
            images: [],
            comment: %i[id body user_id _destroy]
          )
  end
end
