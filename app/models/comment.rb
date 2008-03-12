class Comment < DataMapper::Base
#  include DataMapper::Reflection

  property :body,           :text
  property :created_at,     :datetime
  property :author_name,    :text
  property :author_email,   :text
  property :author_website, :text

  belongs_to :blog

  before_save :validate_open_comments

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