class HomeController < ApplicationController
  def index
    @tutorials = Tutorial.published.recently_published.limit(6)
    @posts = Post.published.recently_published.limit(6)
    @docs_toc = Doc.grouped(%i(title slug))
  end
end
