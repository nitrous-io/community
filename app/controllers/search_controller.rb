class SearchController < ApplicationController
  def search
    @smallNavTitle = 'Search'
    type = params[:type] || 'all'

    case type
      when 'all'
        @posts = Post.published.advanced_search(params['q']).limit(6)
        @tutorials = Tutorial.published.advanced_search(params['q']).limit(6)
      when 'posts'
        p = Pagination.new(Post.published.advanced_search(params['q']), per_page: params[:per_page].to_i, page: params[:page].to_i)
        next_page_path = search_path(p.options_for_next_page.merge(type: type))
        render partial: 'posts/list', locals: { posts: p.items, next_page_path: next_page_path }
      when 'tutorials'
        p = Pagination.new(Tutorial.published.advanced_search(params['q']), per_page: params[:per_page].to_i, page: params[:page].to_i)
        next_page_path = search_path(p.options_for_next_page.merge(type: type))
        render partial: 'tutorials/list', locals: { tutorials: p.items, next_page_path: next_page_path }
    end
  end
end