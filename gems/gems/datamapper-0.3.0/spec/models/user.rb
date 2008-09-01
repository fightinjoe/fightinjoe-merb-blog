# This uses the inheritance method of declaring
# a model to boost spec coverage and ensure that the to
# ways of declaring a model are compatible within the
# same project and/or object graphs.
class User < DataMapper::Base
  
  property :name, :string
  property :email, :string, :format => :email_address
  has_many :comments, :class => 'Comment', :foreign_key => 'user_id'
  
  after_create { false }
end