class Category < DataMapper::Base
  include DataMapper::Reflection

  property :title, :string

  has_many :blogs
end