require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Comment, 'Callback methods' do
  before(:each) do
    create_blog = lambda { |title, date_diff|
      Comment.new(
        :title => title,
        :body => 'b',
        :author_name => 'an',
        :comments_expire_at => mock('datetime', :to_date => Date.today + date_diff )
      )
    }
    @today     = create_blog.call( 'today', 0 )
    @tomorrow  = create_blog.call( 'tomorrow', 1 )
    @yesterday = create_blog.call( 'yesterday', -1 )
  end

#  it 'should know when comments close' do           # comments_closed?
##    lambda { Comment.count }.should be_different_by(0) { Comment.create( :blog => @yesterday) }
#    debugger
#    Comment.create( :blog => @yesterday ).new_record?.should == true
#    Comment.create( :blog => @today ).new_record?.should     == true
#    Comment.create( :blog => @tomorrow ).new_record?.should  == false
#  end
end

describe Comment, 'Validations' do
  before(:each) do
    Comment.delete_all
  end

  it 'shoulc create when all validations are satisfied' do
    lambda { Comment.count }.should be_different_by(1) {
      Comment.create( default_options )
    }
  end

  it 'should reqire that an name be left' do
    lambda { Comment.count }.should be_different_by(0) {
      Comment.create( default_options( :author_name => nil ) )
    }
  end

  it 'should require there to be a body' do
    lambda { Comment.count }.should be_different_by(0) {
      Comment.create( default_options( :body => nil ) )
    }
  end
end

def default_options( options = {} )
  { :body => 'body', :author_name => 'name' }.merge( options )
end