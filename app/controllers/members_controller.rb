class MembersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:show, :update_face_scan, :remove_face_scan]
  skip_before_action :verify_authenticity_token, only: [:update_face_scan, :remove_face_scan]
  include Pagy::Backend
  before_action :set_member, only: [:edit, :show, :unregister_face_scan, :change_plan, :update_plan]
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
    @products  = Product.active.includes(:product_plans).all
    @genders   = User.genders.keys
  end

  def create
    subscription = UserSubscription.new(user: nil, product_plan: @plan, product: nil, options: member_params)
    if subscription.register
      redirect_to checkout_transactions_path(customer_number: subscription.user.customer_number)
    else
      @member    = subscription.user
      @products  = Product.active.includes(:product_plans).all
      @genders   = User.genders.keys
      render :new, status: :unprocessable_entity
    end
  end

  def show
    respond_to do |format|
      format.json {
        if member_inactive?
          render json: @member.as_json(
            include: { subscription: { methods: [:active?] } },
            methods: :fullname
          ).merge(error: "User is inactive"), status: :unprocessable_entity
        else
          render json: @member,
                 include: { subscription: { methods: [:active?] } },
                 methods: :fullname
        end
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

  def on_plan_change
    @plans = ProductPlan.active.where(product_id: params[:product_id]).order(:price_cents)
  end

  def change_plan
    @products = Product.active.includes(:product_plans)
    current_product = @member.subscription&.product_plan&.product
    @plans = current_product&.product_plans&.active&.order(:price_cents) || []
  end

  def update_plan
    subscription = @member.subscription
    new_plan = ProductPlan.find_by(id: params[:product_plan_id])

    if new_plan && subscription.update(product_plan: new_plan)
      flash[:notice] = "Subscription plan updated successfully"
    else
      flash[:alert] = "Failed to update subscription plan"
    end
    redirect_to edit_member_path(@member.customer_number)
  end

  def update_face_scan
    member = User.members.find_by(customer_number: params[:customer_number])

    if member
      member.update(face_scan: true)
    end

    head :no_content
  end

  def remove_face_scan
    member = User.members.find_by(customer_number: params[:customer_number])

    if member
      member.update(face_scan: false)
      render json: { status: "success", customer_number: member.customer_number }
    else
      render json: { error: "Member not found" }, status: :not_found
    end
  end

  def unregister_face_scan
    api_url = "#{ENV.fetch('FACE_SCAN_API_URL', 'http://127.0.0.1:5000')}/unregister/#{@member.customer_number}"
    uri = URI(api_url)

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 10, read_timeout: 10) do |http|
      http.delete(uri.path)
    end

    case response
    when Net::HTTPSuccess
      @member.update(face_scan: false)
      flash[:notice] = "Face scan unregistered successfully"
    when Net::HTTPNotFound
      flash[:alert] = "User not found in face scan system"
    else
      flash[:alert] = "Failed to unregister face scan"
    end

    redirect_to edit_member_path(@member.customer_number)
  rescue Errno::ECONNREFUSED, Net::OpenTimeout, Net::ReadTimeout, EOFError => e
    Rails.logger.error("Face scan API error: #{e.message}")
    flash[:alert] = "Could not connect to face scan service"
    redirect_to edit_member_path(@member.customer_number)
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

  def member_inactive?
    return true if @member.inactive?
    return true if @member.subscription&.expired?

    false
  end
end
