class PostsController < ApplicationController
  include Pageable
  before_action :verify_admin, except: %i(index show)

  def new
    @post = Post.new
    @smallNavTitle = 'Draft'
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
    @smallNavTitle = 'Edit'
  end

  def update
    @post = Post.find(params[:id].to_i)

    if params[:publish] == 'true'
      if @post.publish_with(post_params, params[:post][:published_at])
        flash[:success] = 'Post has been published'
        redirect_to posts_path
        return
      end
    else
      if @post.update_attributes(post_params)
        flash[:success] = 'Post has been updated'
        if @post.published?
          redirect_to posts_path
        else
          redirect_to drafts_path
        end
        return
      end
    end

    flash[:error] = 'Unable to update post'
    render :edit
  end

  def index
    @posts = params[:tag] ? Post.published.tagged_with(params[:tag]) : Post.published
    @posts = @posts.recently_updated.page(page).per(per_page)

    respond_to do |format|
      format.js
      format.html
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
    published_at = params[:post] ? params[:post][:published_at] : nil
    if @post.publish_with({}, published_at)
      flash[:success] = 'Post has been published'
      redirect_to posts_path
    else
      flash[:error] = 'Unable to publish post'
      redirect_to :back
    end
  end

  def unpublish
    @post = Post.find(params[:id].to_i)
    if @post.unpublish
      flash[:success] = 'Post has been unpublished'
      redirect_to drafts_path
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
