class EquipmentCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_equipment_category, only: [:edit, :update]
  include Pagy::Backend

  def index
    add_breadcrumb "Equipment Categories", :equipment_categories_path

    records = EquipmentCategory.all.includes(:equipment)
    @search = records.ransack(params[:q])
    @pagy, @equipment_categories = pagy(@search.result)
  end

  def new
    @equipment_category = EquipmentCategory.new
  end

  def create
    @equipment_category = EquipmentCategory.new(equipment_category_params)

    respond_to do |format|
      if @equipment_category.save
        format.turbo_stream
        format.html { redirect_to equipment_categories_path, notice: "Equipment category was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("equipment_category_form", partial: "equipment_categories/form", locals: { equipment_category: @equipment_category }), status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @equipment_category.update(equipment_category_params)
        format.turbo_stream
        format.html { redirect_to equipment_categories_path, notice: "Equipment category was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("equipment_category_form", partial: "equipment_categories/form", locals: { equipment_category: @equipment_category }), status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_equipment_category
    @equipment_category = EquipmentCategory.find(params[:id])
  end

  def equipment_category_params
    params.require(:equipment_category).permit(:name, :desciption)
  end
end
