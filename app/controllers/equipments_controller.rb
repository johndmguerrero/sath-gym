class EquipmentsController < ApplicationController
  before_action :set_equipment, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  include Pagy::Backend

  def index
    add_breadcrumb "Equipments", :equipments_path

    records = Equipment.includes(:equipment_categories)
    @search = records.ransack(params[:q])
    @pagy, @equipments = pagy(@search.result)
  end

  def new
    add_breadcrumb "New Equipment"

    @equipment = Equipment.new
  end

  def create
    @equipment = Equipment.new(equipment_params)

    if @equipment.save
      redirect_to equipments_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    add_breadcrumb "Equipment: #{@equipment.name}"
  end

  def update
    if @equipment.update(equipment_params)
      redirect_to equipments_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy

  end

  private

  def set_equipment
    @equipment = Equipment.find(params[:id])
  end

  def equipment_params
    params.require(:equipment).permit(
      :name,
      :description,
      :height,
      :weight,
      :sku,
      :brand,
      :quantity,
      :equipment_categories_id
    )
  end
end
