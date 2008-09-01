require File.dirname(__FILE__) + "/spec_helper"

describe DataMapper::Adapters::Sql::Mappings::Schema do
  it "should return all tables from the database schema" do
    database.adapter.schema.database_tables.size.should == Dir[File.dirname(__FILE__) + '/fixtures/*'].size
    database.adapter.schema.database_tables.each { |table| table.should be_a_kind_of( DataMapper::Adapters::Sql::Mappings::Table ) }
  end
end
