class PlansController < ApplicationController

  def index
    add_breadcrumb "Tier/Plans", :plans_path
  end
end
