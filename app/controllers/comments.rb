class Comments < Application
  # provides :xml, :yaml, :js
  before :login_required, :exclude => %w(index new create)

  def index
    provides :rss, :html
    redirect('/') and return unless logged_in?
    @comments = Comment.all( :order => 'created_at DESC', :limit => 30 )
    render
  end

  def show
    @comment = Comment.first(params[:id])
    raise NotFound unless @comment
    display @comment
  end

  def new
    provides :js, :html
    @blog = params[:blog_id] ? Blog.get( params[:blog_id] ) : nil
    @comment = Comment.new( :blog_id => params[:blog_id] )
    render
  end

  def edit
    only_provides :html
    @comment = Comment.first(params[:id])
    raise NotFound unless @comment
    render
  end

  def create
    params[:comment][:blog_id] = params[:blog_id]
    @comment = Comment.new(params[:comment])

    if @comment.save
      if @comment.blog_id.nil?
        send_contact_email
        redirect( '/' )
      else
        flash[:notice] = 'Thanks for sharing!  Your comment will appear below.'
        redirect( url(:blog_by_date, @comment.reload.blog) )
      end
    else
      render :new
    end
  end

  def update
    @comment = Comment.first(params[:id])
    raise NotFound unless @comment
    if @comment.update_attributes(params[:comment])
      redirect url(:comment, @comment)
    else
      raise BadRequest
    end
  end

  def destroy
    @comment = Comment.first(params[:id])
    @blog = @comment.blog
    raise NotFound unless @comment
    if @comment.destroy!
      @blog ? redirect( url(:blog, @blog) ) : redirect( url(:comments) )
    else
      raise BadRequest
    end
  end

  private

    def send_contact_email
      send_mail( CommentMailer, :contact, {
        :from    => "%s <%s>" % [ @comment.author_name, @comment.author_email ],
        :to      => "aaron@fightinjoe.com",
        :subject => 'Contact via FightinJoe.com from %s' % @comment.author_name
      }, { :comment => @comment } )
    end
end
