class MembersController < ApplicationController
  before_action :authenticate_user!
  include Pagy::Backend
  before_action :set_member, only: [:edit]

  def index
    add_breadcrumb "Members", :members_path

    records = User.members
    @search = records.ransack(params[:q])
    @pagy, @members = pagy(@search.result)
  end

  def new
    add_breadcrumb "Members", :members_path
    add_breadcrumb "Add Member"

  end

  def edit
    add_breadcrumb "Members", :members_path
    add_breadcrumb "#{@member.customer_number}"

  end

  private

  def set_member
    @member = User.members.find_by_customer_number(params[:id])
  end
end
