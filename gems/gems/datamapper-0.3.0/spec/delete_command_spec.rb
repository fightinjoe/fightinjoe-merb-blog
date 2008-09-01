require File.dirname(__FILE__) + "/spec_helper"

describe "Delete Command" do
  
  it "should drop and create the table" do
    database.schema[Zoo].drop!.should == true
    database.schema[Zoo].exists?.should == false
    database.schema[Zoo].create!.should == true
  end
  
end