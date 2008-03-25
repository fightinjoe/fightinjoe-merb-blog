require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')
include UserSpecHelper

describe Admin::Blogs, "index action" do
  before(:each) do
    dispatch_to(Admin::Blogs, :index)
  end
end

describe Admin::Blogs, "edit action" do
  before(:each) do
    @blog = mock("blog", :id => 1)
    Blog.should_receive(:first).with('1').and_return( @blog )

    [User, Blog].collect(&:delete_all)
    @quentin = User.create(valid_user_hash.with(:login => "quentin", :password => "test", :password_confirmation => "test"))

    @controller = dispatch_to( Admin::Blogs, :edit, :id => 1 ) { |request|
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

describe Admin::Blogs, "update action" do
  before(:each) do
    [User, Blog].collect(&:delete_all)
    @quentin = User.create(valid_user_hash.with(:login => "quentin", :password => "test", :password_confirmation => "test"))
    @title = 'title'
    @blog  = Blog.create( :title => 'blog' )

    #@controller = put("/admin/blogs/#{ @blog.id }/edit", :blog => {:title => @title}) { |request|
    @controller = dispatch_to( Admin::Blogs, :update, :id => @blog.id, :blog => {:title => @title} ) { |request|
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

describe Admin::Blogs, "new action" do
  before(:each) do
    [User, Blog].collect(&:delete_all)
    @quentin = User.create(valid_user_hash.with(:login => "quentin", :password => "test", :password_confirmation => "test"))

    #@controller = get('/admin/blogs/new') { |request|
    @controller = dispatch_to( Admin::Blogs, :new ) { |request|
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

describe Admin::Blogs, "create action" do
  before(:each) do
    @title      = 'title'
    [User, Blog].collect(&:delete_all)
    @quentin = User.create(valid_user_hash.with(:login => "quentin", :password => "test", :password_confirmation => "test"))
  
    #@controller = post('/admin/blogs/new', :blog => { :title => 'title' }) { |request|
    @controller = dispatch_to( Admin::Blogs, :create, :blog => { :title => 'title' }) { |request|
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
      #@controller = post( '/admin/blogs/new', :blog => {
      @controller = dispatch_to( Admin::Blogs, :create, :blog => {
        "body"=>"h2. Complete\r\n\r\n* Add categories\r\n** add sidebar categories\r\n* Add RedCloth\r\n* add caching of html content\r\n* Add comment expiration\r\n* Add Flickr\r\n\r\nh2. To Do\r\n\r\n* Add authentication\r\n* Add Contact option\r\n* Add static option for blogs\r\n* Caching\r\n* captcha\r\n* comment RSS feed",
        "title"=>"To-do list", "category_id"=>"1", "comments_expire_at"=>{"month"=>1, "day"=>1, "year"=>2008}
      }) { |request| request.stub!(:current_user).and_return(@quentin) }
    end.should change(Blog, :count).by(1)
  end
end
