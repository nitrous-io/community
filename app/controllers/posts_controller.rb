class PostsController < ApplicationController
  before_action :verify_admin, except: %i(index show)
  before_action :show_publish_menu, only: %(new edit create update)

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
    @posts = params[:tag] ? Post.published.tagged_with(params[:tag]) : Post.published
  end

  def show
    @post = collection.friendly.find(params[:slug])
    @comment = Comment.new
    @comments = @post.comments
  end

  def destroy
    @post = Post.find(params[:id].to_i)
    if @post.deleted!
      flash[:success] = 'Post has been deleted'
      redirect_to posts_path
    else
      flash[:error] = 'Unable to delete post'
      redirect_to :back
    end
  end

  def publish
    @post = Post.find(params[:id].to_i)
    published_at = params[:post] && params[:post][:published_at] ? params[:post][:published_at] : Time.now
    if @post.update_attributes(state: :published, published_at: published_at)
      flash[:success] = 'Post has been published'
      redirect_to posts_path
    else
      flash[:error] = 'Unable to publish post'
      redirect_to :back
    end
  end

  def unpublish
    @post = Post.find(params[:id].to_i)
    if @post.update_attributes(state: :draft, published_at: nil)
      flash[:success] = 'Post has been unpublished'
      redirect_to posts_path
    else
      flash[:error] = 'Unable to unpublish post'
      redirect_to :back
    end
  end

  protected
  def show_publish_menu
    @edit_mode = true
  end

  def post_params
    params.require(:post).permit(:title, :content_markdown, :tag_list, :cover_image_url)
  end

  def collection
    @collection ||= current_user.try(:admin?) ? Post.unscoped : Post.published
  end
end
