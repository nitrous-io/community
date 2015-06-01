class HomeController < ApplicationController
  def index
    @tutorials = Tutorial.active
    @posts = Post.active
  end
end