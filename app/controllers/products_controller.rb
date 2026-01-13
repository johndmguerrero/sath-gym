class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:edit, :update, :destroy, :toggle_status]

  def index
    add_breadcrumb "Product & Plans"

    @products = Product.all
  end

  def new
    add_breadcrumb "Product & Plans", :products_path
    add_breadcrumb "Create Product"

    @product = Product.new
    @product.product_plans.build
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to edit_product_path(@product)
    else
      add_breadcrumb "Product & Plans", :products_path
      add_breadcrumb "Create Product"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    add_breadcrumb "Product & Plans", :products_path
    add_breadcrumb "Edit \"#{@product.name}\""
  end

  def update
    if @product.update(product_params)
      redirect_to edit_product_path(@product)
    else
      add_breadcrumb "Product & Plans", :products_path
      add_breadcrumb "Edit \"#{@product.name}\""
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_status
    @product.update(status: params[:status])
  end

  def destroy

  end

  def set_product
    @product = Product.includes(:product_plans).find_by_id(params[:id])
    redirect_to products_path, alert: "Product not found" unless @product
  end

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :status,
      product_plans_attributes: [
        :id,
        :interval,
        :interval_count,
        :price,
        :price_currency,
        :status,
        :_destroy
      ]
    )
  end
end
