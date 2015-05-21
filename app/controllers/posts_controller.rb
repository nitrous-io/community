class PostsController < ApplicationController
  DEFAULT_TYPE=:blog

  before_action :verify_admin, only: [:new, :create]

  def new
    @post = Post.new
    if params[:type]
      @post.type = params[:type]
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      flash[:success] = '%s has been uploaded' % @post.type.titleize
      redirect_to posts_path
    else
      flash[:error] = 'Unable to upload %s' % @post.type.titleize
      render :new
    end
  end

  def index
    @type = params.fetch(:type, DEFAULT_TYPE)
    @posts = Post.where(type: @type)
    @posts = @posts.tagged_with(params[:tag]) if params[:tag]
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
