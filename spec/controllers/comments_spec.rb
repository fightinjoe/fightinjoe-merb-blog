require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Comments, "index action" do
  before(:each) do
    @controller = Comments.build(fake_request)
    @controller.dispatch('index')
  end
end

describe Comments, "create action" do
  before(:each) do
  end

  it "should send an email when there is no blog id" do
    lambda { Comment.count }.should be_different_by(1) {
      lambda { Merb::Mailer.deliveries.size }.should be_different_by(1) {
        @controller = dispatch_to( Comments, 'create', :comment => { :body => 'body', :author_name => 'name', :author_email => 'email' } )
      }
    }
  end
end