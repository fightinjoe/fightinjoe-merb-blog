require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidatesAcceptanceOfTest < Test::Unit::TestCase
  test "valid acceptance" do
    validation = Validatable::ValidatesAcceptanceOf.new stub_everything, :acceptance
    instance = stub(:acceptance=>'true')
    assert_equal true, validation.valid?(instance)
  end
  
  test "invalid acceptance" do
    validation = Validatable::ValidatesAcceptanceOf.new stub_everything, :acceptance
    instance = stub(:acceptance=>'false')
    assert_equal false, validation.valid?(instance)
  end
  
  expect true do
    options = {:message => nil, :if => nil, :times => nil, :level => nil, :groups => nil}
    Validatable::ValidatesAcceptanceOf.new(stub_everything, :test).must_understand(options)
  end
  
end