require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Tester do

  it "should not save" do
    t = Tester.create( :name => 'name' )
    t.new_record?.should == true
  end

end