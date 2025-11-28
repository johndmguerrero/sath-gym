class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    add_breadcrumb "Dashboard"

  end
end
