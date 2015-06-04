class SearchController < ApplicationController
  def search
    @smallNavTitle = 'Search'
    @posts = Post.search(params['q'])
    @tutorials = Tutorial.search(params['q'])
  end
end