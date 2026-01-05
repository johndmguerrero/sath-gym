class SocialMediaController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy, :publish, :archive]
  include Pagy::Backend

  def index
    add_breadcrumb "Social Media"

    records = SocialMediaPost.includes(:user)
    @search = records.ransack(params[:q])
    @pagy, @posts = pagy(@search.result, limit: params[:limit] || 10)
  end

  def new
    add_breadcrumb "Social Media", :social_media_path
    add_breadcrumb "New Post"

    @post = SocialMediaPost.new(status: :draft)
  end

  def create
    @post = current_user.social_media_posts.build(post_params)

    if @post.save
      redirect_to social_media_path, notice: "Post created successfully!"
    else
      add_breadcrumb "Social Media", :social_media_path
      add_breadcrumb "New Post"
      render :new, status: :unprocessable_entity
    end
  end

  def generate
    @post = current_user.social_media_posts.create!(
      content: "Generating...",
      status: :draft
    )

    SocialMediaGenerationJob.perform_later(@post.id)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.prepend(
          "posts_table_body",
          partial: "social_media/partials/post_row",
          locals: { post: @post }
        )
      end
      format.html { redirect_to social_media_path, notice: "Generating post..." }
    end
  end

  def show
    add_breadcrumb "Social Media", :social_media_path
    add_breadcrumb "Post ##{@post.id}"
  end

  def edit
    add_breadcrumb "Social Media", :social_media_path
    add_breadcrumb "Edit Post ##{@post.id}"
  end

  def update
    if @post.update(post_params)
      redirect_to social_media_path, notice: "Post updated successfully!"
    else
      add_breadcrumb "Social Media", :social_media_path
      add_breadcrumb "Edit Post ##{@post.id}"
      render :edit, status: :unprocessable_entity
    end
  end

  def publish
    @post.publish!
    redirect_to social_media_path, notice: "Post published!"
  end

  def archive
    @post.archive!
    redirect_to social_media_path, notice: "Post archived."
  end

  def destroy
    @post.destroy
    redirect_to social_media_path, notice: "Post deleted."
  end

  private

  def set_post
    @post = SocialMediaPost.find(params[:id])
  end

  def post_params
    params.require(:social_media_post).permit(:content, :status)
  end
end
