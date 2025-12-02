class AttendancesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :set_user, only: [:create]

  def index
    add_breadcrumb "Attendances"

    @attendances = Attendance.includes(:user).all
  end

  def create
    @attendance = @user.attendances.build(
      remarks: attendance_params[:remarks]
    )

    if @attendance.save
      render json: @user, status: :created
    end
  end

  private

  def set_user
    @user = User.find_by customer_number: attendance_params[:customer_number]
  end

  def attendance_params
    params.require(:attendances).permit(:customer_number, :remarks)
  end
end
