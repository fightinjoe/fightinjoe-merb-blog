require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Blog, 'Callback methods' do
  it "should set the path title when saved" do      # set_path
    title = 'This is my TITLE'
    want  = /this_is_my_title/
    blog  = Blog.create( :title => title )
    blog.path_title.should match want
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
      blog = Blog.create( :title => 'Blog Title', :category_id => title )
    }
    Category.first.title.should match /#{title}/
  end

  it "should cache the body as HTML" do             # cache_body_html
    body = 'this is *strong*'
    want  = '<p>this is <strong>strong</strong></p>'
    blog  = Blog.create( :body => body, :title => 'Blog title', :category_id => 'cat' )
    blog.reload.body_html.should match /#{ want }/

    body = 'changed'
    want = '<p>changed</p>'
    blog.body = body
    blog.save
    blog.reload.body_html.should match /#{ want }/
  end
end