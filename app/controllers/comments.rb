class Comments < Application
  # provides :xml, :yaml, :js
  
  def index
    @comments = Comment.all
    display @comments
  end

  def show
    @comment = Comment.first(params[:id])
    raise NotFound unless @comment
    display @comment
  end

  def new
    only_provides :html
    @comment = Comment.new
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
      redirect blog_path( @comment.reload.blog )
    else
      render :action => :new
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
    raise NotFound unless @comment
    if @comment.destroy!
      redirect url(:comments)
    else
      raise BadRequest
    end
  end
  
end
