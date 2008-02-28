class Blog < DataMapper::Base
  property :title,      :string
  property :path_title, :string
  property :body,       :text
  property :created_at, :datetime
  property :updated_at, :datetime
  property :year,       :integer
  property :month,      :integer

  belongs_to :user
  belongs_to :category
  has_many   :comments

  before_create :set_path_title
  before_create :set_year
  before_create :set_month
  before_save :normalize_category_id

  private

  def set_path_title() self.path_title ||= self.title.downcase.gsub(' ', '_'); end
  def set_year()       self.year         = Time.now.year;  end
  def set_month()      self.month        = Time.now.month; end

  # Before saving, check to make sure that the category_id is set to an integer.
  # If not, create a new category with the title of teh category_id.
  def normalize_category_id
    return if self.category_id.nil?
    if self.category_id.to_i == 0
      category = Category.find_or_create( :title => self.category_id )
      self.category_id = category.id
    end
  end
end