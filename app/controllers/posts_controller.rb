class PostsController < ApplicationController
  include Pageable
  before_action :verify_admin, except: %i(index show)

  def new
    @post = Post.new
    @small_nav_title = 'Draft'
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      flash[:success] = 'Post has been uploaded'
      redirect_to drafts_path
    else
      flash[:error] = 'Unable to upload post'
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id].to_i)
    @small_nav_title = 'Edit'
  end

  def update
    @post = Post.find(params[:id].to_i)

    if @post.present? && @post.update_attributes(post_params)
      flash[:success] = 'Post has been updated'
      redirect_to post_path(@post)
      return
    end

    flash[:error] = 'Unable to update post'
    render :edit
  end

  def index
    posts = params[:tag] ? Post.published.tagged_with(params[:tag]) : Post.published
    @posts = posts.recently_published.page(page).per(per_page)

    if params[:tag].blank?
      @posts = @posts.padding(1)
      @cover_post = posts.recently_published.limit(1)[0] if @_page == 1
    end
  end

  def show
    @post = collection.friendly.find(params[:slug])
    @is_upvoted = @post.is_upvoted_by?(current_user_id)
    @comment = Comment.new
    @comments = @post.comments
  end

  def destroy
    @post = Post.find(params[:id].to_i)
    if @post.present? && @post.deleted!
      flash[:success] = 'Post has been deleted'
      redirect_to posts_path
    else
      flash[:error] = 'Unable to delete post'
      redirect_to :back
    end
  end

  def publish
    @post = Post.find(params[:id].to_i)
    published_at = params[:post] ? params[:post][:published_at] : nil

    if @post.present? && @post.publish_with({}, published_at)
      flash[:success] = 'Post has been published'
      redirect_to post_path(@post)
    else
      flash[:error] = 'Unable to publish post'
      redirect_to :back
    end
  end

  def unpublish
    @post = Post.find(params[:id].to_i)
    if @post.present? && @post.unpublish
      flash[:success] = 'Post has been unpublished'
      redirect_to post_path(@post)
    else
      flash[:error] = 'Unable to unpublish post'
      redirect_to :back
    end
  end

  protected
  def post_params
    params.require(:post).permit(:title, :content_markdown, :tag_list, :cover_image_url)
  end

  def collection
    @collection ||= current_user.try(:admin?) ? Post.unscoped : Post.published
  end
end
