class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    add_breadcrumb "Product & Plans"

  end
end
