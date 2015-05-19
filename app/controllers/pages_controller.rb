class PagesController < ApplicationController
  def home
    @tutorials = Tutorial.all
    @blogs = Blog.all
  end
end
