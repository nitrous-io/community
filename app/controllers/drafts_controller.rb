class DraftsController < ApplicationController
  def index
    @posts = Post.drafted.recently_updated.limit(6)
    @tutorials = Tutorial.drafted.recently_updated.limit(6)
    @smallNavTitle = 'Drafts'
  end
end