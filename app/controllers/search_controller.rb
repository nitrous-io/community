class SearchController < ApplicationController
  include Pageable

  skip_before_action :verify_authenticity_token
  before_action :parse_query, except: %i(index)

  def posts
    @posts = Post.published.recently_published.advanced_search({
      title: @query, content_text: @query, slug: @query
    }, false).page(page).per(per_page)
  end

  def tutorials
    @tutorials = Tutorial.published.recently_published.advanced_search({
      title: @query, content_text: @query, slug: @query
    }, false).page(page).per(per_page)
  end

  def docs
    @docs = Doc.published.recently_published.advanced_search({
      title: @query, content_text: @query, slug: @query
    }, false).page(page).per(per_page)
  end

  protected
  def parse_query
    @query = params['q'].to_s.strip
    @small_nav_title = 'Search'
  end
end
