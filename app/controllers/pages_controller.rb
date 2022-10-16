class PagesController < ApplicationController
  def index; end

  def dashboard
    @customers = Customer.all
  end
end
