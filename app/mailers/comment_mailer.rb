class CommentMailer < Merb::MailController

  def contact
    @comment = params[:comment]
    render_mail( :layout => false )
  end

end