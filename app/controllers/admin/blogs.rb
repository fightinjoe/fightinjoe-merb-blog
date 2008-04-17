module Admin
class Blogs < Application
  before :find_blog,      :only    => %w(show edit destroy)
  before :login_required
  before :configure_layout

  def index
    options = { :category_id => @category ? @category.id : nil, :per_page => 25, :all => true }
    @blogs  = Blog.paginate( options ).page( params[:page] )
    render
  end

  def new
    only_provides :html
    @blog = Blog.new
    render
  end

  def edit
    only_provides :html
    render
  end

  def create
    @blog = Blog.new(params[:blog])
    if @blog.save
      redirect url(:blog, @blog)
    else
      render :action => :new
    end
  end

  def update
    @blog = Blog.first(params[:id])
    raise NotFound unless @blog
    if @blog.update_attributes(params[:blog])
      flash[:notice] = 'Success!  Your blog has been updated.'
      sweep_cache
      redirect url(:admin_blogs, @blog)
    else
      raise BadRequest
    end
  end

  def destroy
    @blog = Blog.first(params[:id])
    raise NotFound unless @blog
    if @blog.destroy!
      redirect url(:blogs)
    else
      raise BadRequest
    end
  end

  private

    def configure_layout
      @body_class   = 'admin'
      @hide_sidebar = true
    end

    def find_blog
      id, page_title, month, year = params[:id], params[:path_title], params[:month], params[:year]
      if id == 'latest'
        @blog = Blog.last
      else
        @blog = id ? Blog.get( id ) : Blog.first( :path_title => page_title, :year => year, :month => month )
      end
      raise NotFound unless @blog
    end

    def sweep_cache
      expire_page( :key => '/index' )
      expire_page( :key => url(:blog_by_date, @blog) )
      expire_page( :key => '/blogs.rss' )
    end

end
end # Admin
