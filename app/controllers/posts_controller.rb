class PostsController < ApplicationController
  before_action :verify_admin, only: [:new, :create]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      flash[:success] = 'Post has been uploaded'
      redirect_to posts_path
    else
      flash[:error] = 'Unable to upload post'
      render :new
    end
  end

  def index
    if params[:tag]
      @posts = Post.tagged_with(params[:tag])
    else
      @posts = Post.all
    end
  end

  def show
    @post = Post.friendly.find(params[:slug])

    @comment = Comment.new
    @comments = @post.comments
  end

  protected
  def post_params
    params.require(:post).permit(:type, :title, :content_markdown, :tag_list)
  end
end
