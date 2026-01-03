class MembersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:show, :update_face_scan]
  skip_before_action :verify_authenticity_token, only: [:update_face_scan]
  include Pagy::Backend
  before_action :set_member, only: [:edit, :show]
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
    @address   = @member.build_user_address
    @products  = Product.includes(:product_plans).all
    @genders   = User.genders.keys
  end

  def create
    subscription = UserSubscription.new(user: nil, product_plan: @plan, product: nil, options: member_params)
    if subscription.register
      redirect_to checkout_transactions_path(customer_number: subscription.user.customer_number), notice: "Member registered successfully. Please complete payment to activate membership."
    else
      @member    = subscription.user
      @products  = Product.includes(:product_plans).all
      @genders   = User.genders.keys
      render :new, status: :unprocessable_entity
    end
  end

  def show
    respond_to do |format|
      format.json {
        render json: @member,
               include: { subscription: { methods: [:active?] } },
               methods: :fullname
      }
    end
  end

  def edit
    add_breadcrumb "Members", :members_path
    add_breadcrumb "#{@member.customer_number}"
  end

  def on_subscription_change
    @plans = ProductPlan.where(product_id: params[:user][:product_id]).order(:price_cents)
  end

  def update_face_scan
    member = User.members.find_by(customer_number: params[:customer_number])

    if member
      member.update(face_scan: true)
    end

    head :no_content
  end

  private

  def set_member
    @member = User.members.includes(:subscription).find_by_customer_number(params[:id])
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
      user_address_attributes: [:region, :province, :city, :barangay],
      subscription_attributes: [:product_plan_id]
    )
  end
end
