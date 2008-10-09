class Category
  include DataMapper::Resource
#  include DataMapper::Reflection

  property :id,    Serial
  property :title, String

  has n, :blogs
end