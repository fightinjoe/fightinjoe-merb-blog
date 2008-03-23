class Blogs < Application
  include Merb::CommentsHelper
  # provides :xml, :yaml, :js

  before :find_blog,      :only    => %w(show edit destroy)
  before :login_required, :exclude => %w(index show)

  # cache_pages :index, :show

  def index
    provides :html, :rss
    if params[:format] == 'rss'
      @blogs = Blog.all( :conditions => ['published_at IS NOT NULL'], :order => 'published_at DESC', :limit => 10 )
    else
      title     = params[:category_title]
      @category = title && Category.first( :title => title )

      raise NotFound if title && @category.nil?

      options = @category ? { :category_id => @category.id } : {}
      @blogs  = Blog.paginate_for( current_user, options ).page( params[:page] )
    end

    render
  end

  def show 
    @comment = Comment.new( :blog_id => @blog.id )
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
      # flash[:notice] = 'Success!  Your blog has been updated.'
      sweep_cache
      redirect url(:blog_by_date, @blog)
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

    def find_blog
      id, page_title, month, year = params[:id], params[:path_title], params[:month], params[:year]
      if id == 'latest'
        @blog = Blog.last
      else
        @blog = id ? Blog.first( id ) : Blog.first( :path_title => page_title, :year => year, :month => month )
      end
      raise NotFound unless @blog
    end

    def sweep_cache
      expire_page( :key => '/index' )
      expire_page( :key => url(:blog_by_date, @blog) )
      expire_page( :key => '/blogs.rss' )
    end

end
