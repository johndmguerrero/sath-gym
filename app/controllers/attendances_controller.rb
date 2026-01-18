class AttendancesController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]
  include Pagy::Backend
  before_action :set_user, only: [:create]

  def index
    add_breadcrumb "Attendances"

    records = Attendance.includes(:user).order(created_at: :desc)
    @search = records.ransack(params[:q])
    @pagy, @attendances = pagy(@search.result)
  end

  def create
    unless @user
      render json: { error: "User not found" }, status: :not_found
      return
    end

    if user_inactive?
      render json: { error: "User is inactive" }, status: :unprocessable_entity
      return
    end

    existing_attendance = @user.attendances.where(created_at: Date.current.all_day).first

    if existing_attendance
      render json: @user, status: :ok
      return
    end

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

  def user_inactive?
    return true if @user.inactive?
    return true if @user.subscription&.expired?

    false
  end
end
