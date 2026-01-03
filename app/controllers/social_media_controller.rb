class SocialMediaController < ApplicationController
  before_action :authenticate_user!

  def index
    add_breadcrumb "Social Media"

  end
end
