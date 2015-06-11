class DraftsController < ApplicationController
  include Pageable

  skip_before_action :verify_authenticity_token
  before_action :verify_admin
  before_action :set_title

  def index
    @tutorials = Tutorial.drafted.recently_updated.page(page).per(per_page)
    @posts = Post.drafted.recently_updated.page(page).per(per_page)
  end

  def posts
    @posts = Post.drafted.recently_updated.page(page).per(per_page)
    respond_to do |format|
      format.js do
        render template: 'posts/index.js'
      end
    end
  end

  def tutorials
    @tutorials = Tutorial.drafted.recently_updated.page(page).per(per_page)
    respond_to do |format|
      format.js do
        render template: 'tutorials/index.js'
      end
    end
  end

  protected
  def set_title
    @smallNavTitle = 'Drafts'
  end
end