class BlogsController < ApplicationController
  before_action :verify_admin, only: [:new, :create]

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(blog_params)
    @blog.author = current_username 
    @blog.content_html = MarkdownService.new.convert_to_html(blog_params[:content_markdown])
    @blog.tag_list = blog_params[:tag_list]

    if @blog.save
      flash[:success] = "Blog has been uploaded"
      redirect_to blogs_path
    else 
      flash[:error] = "Unable to upload blog"
      render :new
    end
  end

  def index
    if params[:tag]
      @blogs = Blog.tagged_with(params[:tag])
    else
      @blogs = Blog.all
    end

  end

  def show
    @blog = Blog.friendly.find(params[:slug])
  end

  private

  def blog_params
    params.require(:blog).permit(:title, :content_markdown, :tag_list)
  end
end
