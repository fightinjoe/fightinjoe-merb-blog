require 'datamapper_reflection'

class Blog < DataMapper::Base
  include DataMapper::Reflection

  property :title,      :string
  property :path_title, :string
  property :body,       :text
  property :body_html,  :text,    :lazy => false, :writer => :private
  property :created_at, :datetime
  property :updated_at, :datetime
  property :year,       :integer
  property :month,      :integer
  property :permalink,  :text
  property :comments_expire_at, :datetime, :reflect => :parse_date

  belongs_to :user
  belongs_to :category
  has_many   :comments

#  validates_presence_of :title

  before_create :set_path_title
  before_create :set_year
  before_create :set_month
  before_save :normalize_category_id

  # The before_save filter doesn't seem to work for both create and update
  before_create :cache_body_html
  before_update :cache_body_html

  private

  def set_path_title() self.path_title ||= self.title.downcase.gsub(' ', '_'); end
  def set_year()       self.year         = Time.now.year;  end
  def set_month()      self.month        = Time.now.month; end

  # Before saving, check to make sure that the category_id is set to an integer.
  # If not, create a new category with the title of teh category_id.
  def normalize_category_id
    return if self.category_id.nil?
    if self.category_id.to_i == -1
      category = Category.find_or_create( :title => self.category_id )
      self.category_id = category.id
    end
  end

  def cache_body_html
    return if self.body.nil?
    self.body_html = RedCloth.new( self.body ).to_html
  end

  def parse_date( date_params )
    d = date_params
    Date.parse('%4d.%2d.%2d' % [d['year'],d['month'],d['day']])
  end
end