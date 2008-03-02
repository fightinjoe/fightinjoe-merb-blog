class Tester < DataMapper::Base
  property :name, :string

  before_save   :return_false
  before_create :return_false

  # This does not work - is there a valid callback to use here?
  # validate      :return_false

  def return_false() return false; end
end