class AttendancesController < ApplicationController

  def index
    add_breadcrumb "Attendances", :attendances_path

  end
end
