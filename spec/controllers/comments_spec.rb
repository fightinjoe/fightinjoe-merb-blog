require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')
#require File.join(File.dirname(__FILE__), "..", '..', 'app', 'models', 'comment')

describe Comments, "index action" do
  before(:each) do
#    @controller = dispatch_to( Comments, 'index', :format => 'rss' )
    #@controller = Comments.build(fake_request)
    #@controller.dispatch('index')
  end

  it "should render the comments as RSS" do
    controller = get('/comments.rss') { |request|
      request.stub!(:current_user).and_return(@quentin)
    }
    controller.status.should == 200
  end

  it "should protect the RSS feed to only logged in users" do
    controller = get('/comments.rss')
    controller.status.should == 302
    controller.should redirect_to '/'
  end

#  it "should assign 30 most recent comments" do
#  end
end

describe Comments, "create action" do
  before(:each) do
    @blog       = Blog.create( blog_options )
    @controller = post("/blogs/#{ @blog.id }/comments/new", :comment => comment_options ) { |req|
      req.stub!(:render)
    }
  end

  it "should send an email when there is no blog id" do
    lambda { Comment.count }.should be_different_by(1) {
      lambda { Merb::Mailer.deliveries.size }.should be_different_by(1) {
        @controller = dispatch_to( Comments, 'create', :comment => { :body => 'body', :author_name => 'name', :author_email => 'email' } )
        @controller.status.should == 302
      }
    }
  end

  it "should set the flash" do
    @controller.flash.empty?.should == false
  end
end

describe Comments, "delete action" do
  before(:each) do
    Comment.delete_all
    @blog    = Blog.create( blog_options )
    @comment = Comment.create( comment_options( :blog_id => @blog.id ) )
    @path    = "/blogs/#{ @blog.id }/comments/#{ @comment.id }"
  end

  it "should delete the comment" do
    lambda { Comment.count }.should be_different_by(-1) {
      delete( @path ) { |request|
        request.stub!(:current_user).and_return(@quentin)
        request.stub!(:render)
      }
    }
  end

  it "should only allow deletion for logged in users" do
    lambda { Comment.count }.should be_different_by(0) {
      delete( @path ) { |request|
        request.stub!(:render)
      }
    }
  end

  it "should redirect to the blog page" do
    lambda { Comment.count }.should be_different_by(-1) {
      @controller = delete( @path ) { |request|
        request.stub!(:current_user).and_return(@quentin)
        request.stub!(:render)
      }
      @controller.status.should == 302
      @controller.should redirect_to url(:blog, @blog)
    }
  end

  it "should set the flash" do
    @controller = delete( @path ) { |request|
      request.stub!(:current_user).and_return(@quentin)
      request.stub!(:render)
    }
    @controller.flash.empty?.should == false
  end
end