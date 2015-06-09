class DraftsController < ApplicationController
  before_action :verify_admin
  before_action :set_title

  def index
    @tutorials = Tutorial.drafted.recently_updated
    @posts = Post.drafted.recently_updated
  end

  # FIXME: Implement properly when we need pagination for draft
  def posts
    pagination = Pagination.new(Post.drafted.recently_updated, per_page: params[:per_page].to_i, page: params[:page].to_i)
    next_page_path = posts_drafts_path(pagination.options_for_next_page)

    if pagination.page > 1
      locals = { posts: pagination.items, next_page_path: next_page_path }
      render partial: 'posts/list', locals: locals
    else
      @posts = pagination.items
      @tutorials = []
      render 'drafts/index'
    end
  end

  # FIXME: Implement properly when we need pagination for draft
  def tutorials
    pagination = Pagination.new(Tutorial.recently_updated, per_page: params[:per_page].to_i, page: params[:page].to_i)
    next_page_path = tutorials_drafts_path(pagination.options_for_next_page)

    if pagination.page > 1
      locals = { tutorials: pagination.items, next_page_path: next_page_path }
      render partial: 'tutorials/list', locals: locals
    else
      @posts = []
      @tutorials = pagination.items
      render 'drafts/index'
    end
  end

  protected
  def set_title
    @smallNavTitle = 'Drafts'
  end
end