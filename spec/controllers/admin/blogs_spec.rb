require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe Admin::Blogs, "index action" do
  before(:each) do
    dispatch_to(Admin::Blogs, :index)
  end
end