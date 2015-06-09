class SearchController < ApplicationController
  def search
    @smallNavTitle = 'Search'
    @posts = Post.published.advanced_search(params['q'])
    @tutorials = Tutorial.published.advanced_search(params['q'])
  end
end