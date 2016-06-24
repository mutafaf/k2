class BlogsController < ApplicationController

  def index
    @blogs = Shoppe::Blog.all.order("position")
    @first_blog = @blogs.first if @blogs
  end

  def show
    @blog = Shoppe::Blog.find_by_permalink(params[:permalink])
  end

end
