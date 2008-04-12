require 'redcloth'

class Blogs < Application
  include Merb::CommentsHelper
  cache_pages :index, :show

  def index
    provides :html, :rss
    if params[:format] == 'rss'
      @blogs = Blog.get_rss
    else
      title     = params[:category_title]
      @category = title && Category.first( :title => title )

      raise NotFound if title && @category.nil?

      options = { :category_id => @category ? @category.id : nil }
      @blogs  = Blog.paginate( options ).page( params[:page] )
    end

    render
  end

  def show 
    find_blog
    @comment = Comment.new( :blog_id => @blog.id )
    render
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
end
