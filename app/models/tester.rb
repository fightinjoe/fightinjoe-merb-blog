class Tester
  include DataMapper::Resource
  property :id,   Serial
  property :name, String

  before :save,   :return_false
  before :create, :return_false

  # This does not work - is there a valid callback to use here?
  # validate      :return_false

  def return_false() return false; end
end