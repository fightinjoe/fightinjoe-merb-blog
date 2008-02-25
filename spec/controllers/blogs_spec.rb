require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Blogs, "index action" do
  before(:each) do
    @controller = Blogs.build(fake_request)
    @controller.dispatch('index')
  end
end