class Blogs < Application
  def index
    @blogs = Blog.all
    render
  end

  def show
    @blog = Blog.first( :year => params[:year], :month => params[:month], :path_title => [:path_title])
    render
  end

  def new
    @blog, @method = Blog.new, 'post'
    render
  end

  def edit
    @blog, @method = Blog.find( params[:id] ), 'put'
    render
  end

  def create
    Blog.create( params[:blog] )
    redirect blogs_path
  end

  def update
  end
end