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

  before_create :set_path_title
  before_create :set_year
  before_create :set_month

  ##
  # Creates a path for finding the blog by year, month, and title
  def path
    raise [ year, month, path_title ].inspect
    "/%4d/%2d/%s" % [ year, month, path_title ]
  end

  private

  def set_path_title() path_title ||= title.downcase.gsub(' ', '_'); end
  def set_year()       year         = Time.now.year;  end
  def set_month()      month        = Time.now.month; end
end