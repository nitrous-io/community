class PagesController < ApplicationController
  def home
    @tutorials = Tutorial.all
  end
end
