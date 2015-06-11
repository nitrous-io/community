class SearchController < ApplicationController
  include Pageable

  skip_before_action :verify_authenticity_token

  def search
    @smallNavTitle = 'Search'
    query = params['q'].strip

    @posts = Post.published.advanced_search(query).page(page).per(per_page)
    @tutorials = Tutorial.published.advanced_search(query).page(page).per(per_page)
  end

  def posts
    @posts = Post.published.advanced_search(params['q'].strip).page(page).per(per_page)
    respond_to do |format|
      format.js do
        render template: 'posts/index.js'
      end
    end
  end

  def tutorials
    @tutorials = Tutorial.published.advanced_search(params['q'].strip).page(page).per(per_page)
    respond_to do |format|
      format.js do
        render template: 'tutorials/index.js'
      end
    end
  end
end