require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Blog do

  # Class method

  it "should set the path title when saved" do
    title = 'This is my TITLE'
    want  = /this_is_my_title/
    blog  = Blog.create( :title => title )
    blog.path_title.should match want
  end

  it "should set the year and month when saved" do
    year, month = Time.now.year, Time.now.month
    blog  = Blog.create( :title => 'title' )
    blog.year.should  equal year
    blog.month.should equal month
  end

end