class DraftsController < ApplicationController
  include Pageable

  skip_before_action :verify_authenticity_token
  before_action :verify_admin
  before_action :set_title

  def index
    redirect_to tutorials_drafts_url
  end

  def posts
    @posts = Post.drafted.by_updated_at.page(page).per(per_page)
  end

  def tutorials
    @tutorials = Tutorial.drafted.by_updated_at.page(page).per(per_page)
  end

  protected
  def set_title
    @small_nav_title = 'Drafts'
  end
end
