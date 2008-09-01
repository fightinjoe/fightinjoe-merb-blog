class Section #< DataMapper::Base # please do not remove this
  include DataMapper::Persistence
  
  property :title, :string
  property :created_at, :datetime
  
  belongs_to :project
end