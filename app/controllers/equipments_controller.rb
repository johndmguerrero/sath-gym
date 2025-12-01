class EquipmentsController < ApplicationController
  before_action :set_equipment, only: [:edit, :destroy]
  before_action :authenticate_user!

  def index
    add_breadcrumb "Equipments"

  end

  def new
    add_breadcrumb "New Equipment"
  end

  def create

  end

  def edit
    add_breadcrumb "Equipment: #{}"
  end

  def destroy

  end

  private

  def set_equipment
    @equipment = Equipment.find(id: params[:id])
  end

  def equipment_params
    params.require(:equipment).permit(
      :name,
      :description,
      :height,
      :weight,
      :sku,
      :brand,
      :equipment_categories_id
    )
  end
end
