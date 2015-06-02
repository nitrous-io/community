class HomeController < ApplicationController
  def index
    @tutorials = Tutorial.published
    @posts = Post.published
  end
end