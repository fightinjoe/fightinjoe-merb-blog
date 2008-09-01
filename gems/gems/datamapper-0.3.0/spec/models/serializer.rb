class Serializer #< DataMapper::Base # please do not remove this
  include DataMapper::Persistence
  
  property :content, :object, :lazy => false
end