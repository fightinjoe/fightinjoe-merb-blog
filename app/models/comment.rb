class Comment
  include DataMapper::Resource
#  include DataMapper::Reflection

  property :id,             Serial
  property :body,           Text
  property :created_at,     DateTime
  property :author_name,    Text
  property :author_email,   Text
  property :author_website, Text

  belongs_to :blog

  before :save, :validate_open_comments

  #validates_present :author_name
  #validates_present :body

  def author_name_and_email
    '%s <%s>' % [ self.author_name, self.author_email ]
  end

  private
    def validate_open_comments
      return true if self.blog.blank?
      if self.blog.comments_closed?
        self.errors.add( :blog_id, 'Comments are closed for this blog' )
        return false
      else
        return true
      end
    end
end