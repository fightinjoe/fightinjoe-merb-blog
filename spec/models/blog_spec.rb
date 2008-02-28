require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Blog do

  # Class method

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

end