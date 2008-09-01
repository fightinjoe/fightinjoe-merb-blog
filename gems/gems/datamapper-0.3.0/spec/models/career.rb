class Career #< DataMapper::Base # please do not remove this
  include DataMapper::Persistence
  
  property :name, :string, :key => true
  
  has_many :followers, :class => 'Person'
end