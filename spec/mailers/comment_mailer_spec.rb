require File.join( File.dirname(__FILE__), "..", "spec_helper" )

class Merb::Mailer
  self.delivery_method = :test_send
end

def comment
  Comment.new( :body => 'This is the body', :author_name => 'Author Name', :author_email => 'Author Email' )
end

class TestController < Merb::Controller
  def send_contact
    send_mail( CommentMailer, :contact, {:from => "foo@bar.com", :to => "foo@bar.com"}, {:comment => comment} )
  end
end

describe CommentMailer, 'comment email' do

  undef :call_action if defined?(call_action)
  def call_action(action)
    dispatch_to(TestController, action)
    @delivery = Merb::Mailer.deliveries.last  
  end

  it "should place the body of the content as the body of the email" do
    call_action( :send_contact )
    @delivery.text.should satisfy { |text| text.match( comment.body ) }
  end

  it "should place the name of the author in the body of the email" do
    call_action( :send_contact )
    @delivery.text.should satisfy { |text| text.match( comment.author_name ) }
  end

  it "should place the email of the author in the body of the email" do
    call_action( :send_contact )
    @delivery.text.should satisfy { |text| text.match( comment.author_email ) }
  end

end