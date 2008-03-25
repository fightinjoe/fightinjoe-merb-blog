require File.join(File.dirname(__FILE__),  "..", 'spec_helper.rb')
include UserSpecHelper

describe Blogs, "index action" do
  before(:each) do
    Blog.delete_all
    Category.delete_all
    @blog1 = Blog.create( blog_options )
    @blog2 = Blog.create( blog_options )
    @blogs = [ @blog1, @blog2 ]

    #Blogs.any_instance.expects(:<p>render</p>)
    @controller = dispatch_to( Blogs, 'index', :action => :index ) { |controller| controller.stub!(:render) }
  end

  it "should get successfully" do
    @controller.status.should == 200
  end

  it "should assign all blogs" do
    @controller.assigns(:blogs).count.should == 2
  end

  it "should filter by category" do
    cat1 = Category.create( :title => 'category1' )
    cat2 = Category.create( :title => 'category2' )

    2.times { Blog.create( blog_options.merge(:category_id => cat1.id) ) }
    2.times { Blog.create( blog_options.merge(:category_id => cat2.id) ) }

    @controller = get("/#{ cat1.title }") { |req| req.stub!(:render) }
    @controller.assigns(:category).should    == cat1
    @controller.assigns(:blogs).count.should == 2
    @controller.assigns(:blogs).collect(&:category_id).uniq.first.should == cat1.id
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
