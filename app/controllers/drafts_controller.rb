class DraftsController < ApplicationController
  before_action :verify_admin
  before_action :set_title

  def index
    @tutorials = Tutorial.drafted.recently_updated.limit(6)
    @posts = Post.drafted.recently_updated.limit(6)
  end

  def posts
    pagination = Pagination.new(Post.drafted.recently_updated, per_page: params[:per_page].to_i, page: params[:page].to_i)
    next_page_path = posts_drafts_path(pagination.options_for_next_page)

    if pagination.page > 1
      locals = { posts: pagination.items, next_page_path: next_page_path, more: pagination.more? }
      render partial: 'posts/list', locals: locals
    else
      @next_page_path = next_page_path
      @posts = pagination.items
      @more = pagination.more?
    end
  end

  def tutorials
    pagination = Pagination.new(Tutorial.recently_updated, per_page: params[:per_page].to_i, page: params[:page].to_i)
    next_page_path = tutorials_drafts_path(pagination.options_for_next_page)

    if pagination.page > 1
      locals = { tutorials: pagination.items, next_page_path: next_page_path, more: pagination.more? }
      render partial: 'tutorials/list', locals: locals
    else
      @next_page_path = next_page_path
      @tutorials = pagination.items
      @more = pagination.more?
    end
  end

  protected
  def set_title
    @smallNavTitle = 'Drafts'
  end
end