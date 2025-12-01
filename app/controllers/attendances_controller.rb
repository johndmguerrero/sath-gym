class AttendancesController < ApplicationController
  before_action :set_user, only: [:create]

  def index
    add_breadcrumb "Attendances"

  end

  def create
    @attendance = @user.attendances.build(
      remarks: params[:remarks]
    )

    if @attendance.save
      # return a json for view facescan after success in show info
    end
  end

  private

  def set_user
    @user = User.find_by customer_number: params[:customer_number]
  end
end
