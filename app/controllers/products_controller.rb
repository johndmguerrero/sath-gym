class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:edit, :destroy, :toggle_status]

  def index
    add_breadcrumb "Product & Plans"

    @products = Product.all
  end

  def new
    add_breadcrumb "Product & Plans", :products_path
    add_breadcrumb "Create Product"

  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to edit_product_path(id: @product.id), notice: "Product successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    add_breadcrumb "Product & Plans", :products_path
    add_breadcrumb "Edit \"#{@product.name}\""

  end

  def toggle_status
    @product.update(status: params[:status])
  end

  def destroy

  end

  def set_product
    @product = Product.includes(:product_plans).find_by_id(params[:id])
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
        :price_cents,
        :price_currency,
        :status,
        :_destroy
      ]
    )
  end
end
