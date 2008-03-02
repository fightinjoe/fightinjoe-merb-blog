class Comment < DataMapper::Base
  include DataMapper::Reflection

  property :body,           :text
  property :created_at,     :datetime
  property :author_name,    :text
  property :author_website, :text

  belongs_to :blog

  before_save :validate_open_comments

  private
    def validate_open_comments
      if self.blog.comments_closed?
        self.errors.add( :blog_id, 'Comments are closed for this blog' )
        return false
      else
        return true
      end
    end
end