class MembersController < ApplicationController
  before_action :authenticate_user!
  include Pagy::Backend
  before_action :set_member, only: [:edit]
  before_action :set_product_plan, only: [:create]

  def index
    add_breadcrumb "Members", :members_path

    records = User.members
    @search = records.ransack(params[:q])
    @pagy, @members = pagy(@search.result)
  end

  def new
    add_breadcrumb "Members", :members_path
    add_breadcrumb "Add Member"

    @member    = User.new
    @products  = Product.includes(:product_plans).all
    @genders   = User.genders.keys
  end

  def create
    subscription = UserSubscription.new(user: nil, product_plan: @plan, product: nil, options: member_params)
    if subscription.register
      redirect_to edit_member_path(subscription.user.customer_number)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    add_breadcrumb "Members", :members_path
    add_breadcrumb "#{@member.customer_number}"
  end

  def on_subscription_change
    @plans = ProductPlan.where(product_id: params[:user][:product_id]).order(:price_cents)
  end

  private

  def set_member
    @member = User.members.find_by_customer_number(params[:id])
  end

  def set_product_plan
    @plan = ProductPlan.find_by_id(params[:user][:subscription_attributes][:product_plan_id])
  end

  def member_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :height,
      :weight,
      :nickname,
      :email,
      :phone_number,
      :gender,
      :date_of_birth,
      :address,
      subscription_attributes: [:product_plan_id]
    )
  end
end
