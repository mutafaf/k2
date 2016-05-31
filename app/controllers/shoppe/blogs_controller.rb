class Shoppe::BlogsController < Shoppe::ApplicationController
  before_filter { @active_nav = :blogs }
  before_filter :find_blog, only: [:edit, :update, :destroy]

  def index
    @query = Shoppe::Blog.all.page(params[:page]).search(params[:q])
    @blogs = @query.result
  end

  def new
    @blog = Shoppe::Blog.new
  end

  def create
    @blog = Shoppe::Blog.new(blog_params)
    if @blog.save
      redirect_to :blogs, flash: { notice: t('shoppe.blogs.created_successfully') }
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @blog.update(blog_params)
      redirect_to [:edit, @blog], flash: { notice: t('shoppe.blogs.updated_successfully') }
    else
      render action: 'edit'
    end
  end

  def destroy
    @blog.destroy
    redirect_to blogs_path, flash: { notice: t('shoppe.sizes.deleted_successfully') }
  end

  private

  def blog_params
    file_params = [:file, :parent_id, :role, :parent_type, file: []]
    params[:blog].permit(:title, :description, :permalink, :position, attachments: [default_image: file_params, data_sheet: file_params, extra: file_params])
  end

  def find_blog
    @blog = Shoppe::Blog.find(params[:id])
  end

end
