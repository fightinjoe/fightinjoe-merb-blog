require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Comments, "index action" do
  before(:each) do
    @controller = Comments.build(fake_request)
    @controller.dispatch('index')
  end
end