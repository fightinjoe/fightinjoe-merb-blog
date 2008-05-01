require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe "comments/index.rss" do 
 
  before( :each ) do 
    @controller = Comments.new(fake_request)

    blog = Blog.new( :id => 1, :created_at => Time.now, :title => 'title', :url_title => 'title' )
    comment = Comment.new(:id => 14321295423, :body => "Merb!", :created_at => Time.now, :blog => blog)

    @controller.instance_variable_set(:@comments, [ comment ])  
    @body = @controller.render(:index, :format => :rss) 
  end 
 
  it "should properly set the GUID" do 
    # This test will fail - really I just want to match the text
    # @body.should have_tag(:guid).with_tag(:guid, :text => '#commment_14321295423')
    @body.should satisfy { |rss| rss.match(%r[<guid>[^>]*#comment_14321295423</guid>]) }
  end 
end