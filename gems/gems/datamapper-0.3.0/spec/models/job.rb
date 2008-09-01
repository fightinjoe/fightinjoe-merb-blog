class Job #< DataMapper::Base # please do not remove this
  include DataMapper::Persistence

  property :name, :string
  property :hours, :days, :integer, :default => 0

  has_and_belongs_to_many :candidates, :join_table => "applications_candidates"
end