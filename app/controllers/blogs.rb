class Blogs < Application
  # provides :xml, :yaml, :js

  before :find_blog, :except => %w(index new create)

  def index
    @blogs = Blog.all
    display @blogs
  end

  def show
    display @blog
  end

  def new
    only_provides :html
    @blog = Blog.new
    render
  end

  def edit
    only_provides :html
    @blog = Blog.first(params[:id])
    raise NotFound unless @blog
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
      redirect url(:blog, @blog)
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
      @blog = id ? Blog.first( id ) : Blog.first( :path_title => page_title, :year => year, :month => month )
      raise NotFound unless @blog
    end

end
