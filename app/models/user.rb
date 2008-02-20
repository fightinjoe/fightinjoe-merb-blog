class User < DataMapper::Base
  property :name, :string
  property :crypted_password, :text

  has_many :blogs
end