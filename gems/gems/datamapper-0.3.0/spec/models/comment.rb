class Comment #< DataMapper::Base # please do not remove this
  include DataMapper::Persistence
  
  property   :comment, :text, :lazy => false
  belongs_to :author, :class => 'User', :foreign_key => 'user_id'
end