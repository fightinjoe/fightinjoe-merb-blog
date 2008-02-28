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


  private

  def set_path_title() self.path_title ||= self.title.downcase.gsub(' ', '_'); end
  def set_year()       self.year         = Time.now.year;  end
  def set_month()      self.month        = Time.now.month; end
end