class PostsController < ApplicationController
  before_action :verify_admin, only: [:new, :create]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      flash[:success] = "Blog has been uploaded"
      redirect_to posts_path
    else
      flash[:error] = "Unable to upload blog"
      render :new
    end
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.friendly.find(params[:slug])
  end

  protected
  def post_params
    params.require(:post).permit(:type, :title, :content_markdown, :tag_list)
  end
end
