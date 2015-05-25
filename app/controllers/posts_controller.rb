class PostsController < ApplicationController
  before_action :verify_admin, except: [:index, :show]

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

  def edit
    @post = Post.find(params[:id].to_i)
  end

  def update
    @post = Post.find(params[:id].to_i)
    if @post.update_attributes(post_params)
      flash[:success] = 'Post has been updated'
      redirect_to posts_path
    else
      flash[:error] = 'Unable to update post'
      render :edit
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

  def destroy
    @post = Post.find(params[:id].to_i)
    if @post && @post.deleted!
      flash[:success] = 'Post has been deleted'
      redirect_to posts_path
    else
      flash[:error] = 'Unable to delete post'
      redirect_to :back
    end
  end

  protected
  def post_params
    params.require(:post).permit(:title, :content_markdown, :tag_list)
  end
end
