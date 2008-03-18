class Exceptions < Application
  
  # handle NotFound exceptions (404)
  def not_found
    render :format => :html
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    render :format => :html
  end

  # handle 500 errors
  def internal_server_error
    LoggedException.create_from_controller( self )

    # Required for rendering the exception message - replace for production
    @exception = params[:exception]
    render :format => :html, :layout => :nil
  end

end