class SearchController < ApplicationController
  def search
    @smallNavTitle = 'Search'
    @posts = Post.published.search(params['q'])
    @tutorials = Tutorial.published.search(params['q'])
  end
end