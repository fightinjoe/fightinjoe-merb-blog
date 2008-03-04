require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Comment, 'Callback methods' do
  before(:each) do
    @today     = Blog.new( :title => 'today',     :comments_expire_at => mock('datetime', :to_date => Date.today ) )
    @tomorrow  = Blog.new( :title => 'tomorrow',  :comments_expire_at => mock('datetime', :to_date => Date.today + 1) )
    @yesterday = Blog.new( :title => 'yesterday', :comments_expire_at => mock('datetime', :to_date => Date.today - 1) )
  end

  it 'should know when comments close' do           # comments_closed?
#    lambda { Comment.count }.should be_different_by(0) { Comment.create( :blog => @yesterday) }
    Comment.create( :blog => @yesterday ).new_record?.should == true
    Comment.create( :blog => @today ).new_record?.should     == true
    Comment.create( :blog => @tomorrow ).new_record?.should  == false
  end
end