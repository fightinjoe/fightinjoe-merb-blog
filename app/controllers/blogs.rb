class Blogs < Application
  # provides :xml, :yaml, :js

  before :find_blog,      :only    => %w(show edit destroy)
  before :login_required, :exclude => %w(index show)

  def index
    @blogs = Blog.all
    render
  end

  def show 
    @comment = Comment.new( :blog_id => @blog.id )
    display @blog
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
      # flash[:notice] = 'Success!'
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
        @blog = id ? Blog.first( id ) : Blog.get( :path_title => page_title, :year => year, :month => month )
      end
      raise NotFound unless @blog
    end

end
