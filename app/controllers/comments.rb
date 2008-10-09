class Comments < Application
  provides :html
  before :login_required, :exclude => %w(new create)

  def index
    @comments = Comment.all( :order => 'created_at DESC', :limit => 30 )
    @blogs = Blog.get_rss
    render
  end

  def show
    only_provides :html
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
    params[:comment][:blog_id] = params[:blog_id] unless params[:blog_id].blank?
    @comment = Comment.new(params[:comment])

    if @comment.save
      if @comment.blog_id.nil?
        send_contact_email
        redirect( '/' )
      else
        flash[:notice] = 'Thanks for sharing!  Your comment will appear below.'
        b = @comment.reload.blog
        redirect( url(:blog_by_date, b.year, b.month, b.path_title) )
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
      flash[:notice] = 'Your comment has been successfully deleted'
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
