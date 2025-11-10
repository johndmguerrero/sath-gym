class MembersController < ApplicationController

  def index
    add_breadcrumb "Members", :members_path

    @members = User.members
  end

end
