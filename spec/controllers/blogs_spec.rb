require File.join(File.dirname(__FILE__),  "..", 'spec_helper.rb')
include UserSpecHelper

describe Blogs, "index action" do
  before(:each) do
    @blog1 = mock("blog", :id => 1)
    @blog2 = mock("blog", :id => 2)
    @blogs = [ @blog1, @blog2 ]
    Blog.should_receive(:all).and_return( @blogs )

    #Blogs.any_instance.expects(:render)
    @controller = dispatch_to( Blogs, 'index', :action => :index ) { |controller| controller.stub!(:render) }
  end

  it "should get successfully" do
    @controller.status.should == 200
  end

  it "should assign all blogs" do
    @controller.assigns(:blogs).should == @blogs
  end
end

describe Blogs, "show action" do
  before(:each) do
    @blog = mock("blog", :id => 1)
    @blog.stub!(:comments).and_return( Comment )
    Blog.should_receive(:first).with('1').and_return( @blog )

    #Blogs.any_instance.expects(:render)
    @controller = dispatch_to( Blogs, 'show', :id => 1 ) { |controller| controller.stub!(:render) }
  end

  it "should get successfully" do
    @controller.status.should == 200
  end

  it "should assign blog" do
    @controller.assigns(:blog).should == @blog
  end
end

describe Blogs, "edit action" do
  before(:each) do
    @blog = mock("blog", :id => 1)
    Blog.should_receive(:first).with('1').and_return( @blog )

    [User, Blog].collect(&:delete_all)
    @quentin = User.create(valid_user_hash.with(:login => "quentin", :password => "test", :password_confirmation => "test"))

    @controller = get('/blogs/1/edit') { |request|
      request.stub!(:current_user).and_return(@quentin)
      request.stub!(:render)
    }
  end

  it "should get successfully" do
    @controller.status.should == 200
  end

  it "should assign blog" do
    @controller.assigns(:blog).should == @blog
  end
end

describe Blogs, "update action" do
  before(:each) do
    [User, Blog].collect(&:delete_all)
    @quentin = User.create(valid_user_hash.with(:login => "quentin", :password => "test", :password_confirmation => "test"))
    @title = 'title'
    @blog  = Blog.create( :title => 'blog' )

    @controller = put("/blogs/#{ @blog.id }/edit", :blog => {:title => @title}) { |request|
      request.stub!(:current_user).and_return(@quentin)
      request.stub!(:render)
    }
  end

  it "should redirect" do
    @controller.status.should == 302
  end

  it "should update blog" do
    @blog.reload.title.should == @title
  end
end

describe Blogs, "new action" do
  before(:each) do
    [User, Blog].collect(&:delete_all)
    @quentin = User.create(valid_user_hash.with(:login => "quentin", :password => "test", :password_confirmation => "test"))

    @controller = get('/blogs/new') { |request|
      request.stub!(:current_user).and_return(@quentin)
      request.stub!(:render)
    }
  end

  it "should get successfully" do
    @controller.status.should == 200
  end

  it "should assign empty blog" do
    @controller.assigns(:blog).new_record?.should == true
  end
end

describe Blogs, "create action" do
  before(:each) do
    @title      = 'title'
    [User, Blog].collect(&:delete_all)
    @quentin = User.create(valid_user_hash.with(:login => "quentin", :password => "test", :password_confirmation => "test"))
  
    @controller = post('/blogs/new', :blog => { :title => 'title' }) { |request|
      request.stub!(:current_user).and_return(@quentin)
      request.stub!(:render)
    }
  end
  
  it "should redirect" do
    @controller.status.should == 302
  end
  
  it "should assign newly created blog" do
    Blog.first( :order => 'id DESC' ).title.should == @title
  end
  
  it "should create a new blog" do
    Blog.delete_all
    lambda do
      @controller = post( '/blogs/new', :blog => {
        "body"=>"h2. Complete\r\n\r\n* Add categories\r\n** add sidebar categories\r\n* Add RedCloth\r\n* add caching of html content\r\n* Add comment expiration\r\n* Add Flickr\r\n\r\nh2. To Do\r\n\r\n* Add authentication\r\n* Add Contact option\r\n* Add static option for blogs\r\n* Caching\r\n* captcha\r\n* comment RSS feed",
        "title"=>"To-do list", "category_id"=>"1", "comments_expire_at"=>{"month"=>1, "day"=>1, "year"=>2008}
      }) { |request| request.stub!(:current_user).and_return(@quentin) }
    end.should change(Blog, :count).by(1)
  end
end
