class Blog < DataMapper::Base
  property :title, :string
  property :body, :text
  property :created_at, :datetime

  belongs_to :user
  belongs_to :category
end