require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')
require File.join(File.dirname(__FILE__), "..", '..', 'app', 'models', 'comment')

describe Comments, "index action" do
  before(:each) do
#    @controller = dispatch_to( Comments, 'index', :format => 'rss' )
    #@controller = Comments.build(fake_request)
    #@controller.dispatch('index')
  end

  it "should render the comments as RSS" do
    @controller = dispatch_to( Comments, 'index', :format => 'rss' )
  end

#  it "should assign 30 most recent comments" do
#  end
end

#describe Comments, "create action" do
#  before(:each) do
#  end
#
#  it "should send an email when there is no blog id" do
#    lambda { Comment.count }.should be_different_by(1) {
#      lambda { Merb::Mailer.deliveries.size }.should be_different_by(1) {
#        @controller = dispatch_to( Comments, 'create', :comment => { :body => 'body', :author_name => 'name', :author_email => 'email' } )
#      }
#    }
#  end
#end
#