class Comment < DataMapper::Base
  property :body, :text
  property :created_at, :datetime
  property :author_name, :text
  property :author_website, :text

  belongs_to :blog
end