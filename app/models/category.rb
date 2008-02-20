class Category < DataMapper::Base
  property :title, :string

  has_many :blogs
end