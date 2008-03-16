class Exceptions < Application
  
  # handle NotFound exceptions (404)
  def not_found
    render :format => :html
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    render :format => :html
  end

#  def internal_server_error
#    debugger
#    #MySpecialMailer.deliver(
#    #  "team@cowboys.com", 
#    #  "Exception occured at #{Time.now}", 
#    #  params[:exception])
#    #render :inline => 'Something is wrong, but the team are on it!'
#    render
#  end

end