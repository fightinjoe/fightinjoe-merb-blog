require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Blog, 'Callback methods' do
  before(:each) do
    [Blog, Category].collect(&:delete_all)
  end

  it "should set the path title when saved" do      # set_path
    titles = [
      [ 'TiTlE', 'title' ],
      [ 'another title', 'another-title' ],
      [ "weird &? character's", 'weird-characters' ]
    ]

    titles.each do |title, want|
      blog  = Blog.create( :title => title )
      blog.path_title.should == want
    end
  end

  it "should set the year and month when saved" do  # set_month, set_year
    year, month = Time.now.year, Time.now.month
    blog  = Blog.create( :title => 'title' )
    blog.year.should  equal year
    blog.month.should equal month
  end

  it "should find or create a category" do          # normalize_category_id
    title = 'Category title'
    lambda { Category.count }.should be_different_by(1) {
      @blog = Blog.create( :title => 'Blog Title', :category_id => title )
    }
    category = Category.first( :order => 'id DESC')
    category.title.should match /#{title}/
    @blog.reload.category.should == category
  end

  it "should cache the body as HTML" do             # cache_body_html
    body = 'this is *strong*'
    want  = '<p>this is <strong>strong</strong></p>'
    blog  = Blog.create( :body => body, :title => 'Blog title' )
    blog.reload.body_html.should match /#{ want }/

    body = 'changed'
    want = '<p>changed</p>'
    blog.body = body
    blog.save
    blog.reload.body_html.should match /#{ want }/
  end
end

describe Blog, 'Instance methods' do
  before(:each) do
    @today     = Blog.new( :title => 'today',     :comments_expire_at => mock('datetime', :to_date => Date.today ) )
    @tomorrow  = Blog.new( :title => 'tomorrow',  :comments_expire_at => mock('datetime', :to_date => Date.today + 1) )
    @yesterday = Blog.new( :title => 'yesterday', :comments_expire_at => mock('datetime', :to_date => Date.today - 1) )
  end

  it 'should know when comments close' do           # comments_closed?
    @yesterday.comments_closed?.should == true
    @today.comments_closed?.should     == true
    @tomorrow.comments_closed?.should  == false
  end

  it 'should set the published at date' do
    @today.published = true
    @today.published_at.should_not == nil
  end
end

describe Blog, 'Properties' do
  before(:each) do
  end

  it 'should parse dates propertly' do
    date = Date.today
    blog = Blog.new( :title => 'title', :comments_expire_at => { 'year' => date.year, 'month' => date.month, 'day' => date.day } )
    blog.comments_expire_at.should == date
  end
end