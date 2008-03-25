require 'redcloth'
require 'syntaxi'

class Blog < DataMapper::Base
#  include DataMapper::Reflection

  property :title,        :string
  property :path_title,   :string
  property :body,         :text
  property :body_html,    :text,    :lazy => false, :writer => :private
  property :created_at,   :datetime
  property :updated_at,   :datetime
  property :published_at, :datetime
  property :year,         :integer
  property :month,        :integer
  property :permalink,    :text
  property :comments_expire_at, :datetime #, :reflect => :parse_date

  belongs_to :user
  belongs_to :category
  has_many   :comments

  validates_presence_of :title

  before_create :set_path_title
  before_create :set_year
  before_create :set_month
  before_save   :normalize_category_id

  # The before_save filter doesn't seem to work for update
  before_create :cache_body_html
  before_update :cache_body_html

  class << self
    def last() first( default_options.merge( :conditions => ['published_at IS NOT NULL'] ) ); end

    # Find all published blogs
    def published( options = {} )
      all( default_options.merge( :conditions => ['blogs.published_at IS NOT NULL'] ).merge( options ) )
    end

    def per_page() 10; end

    # Returns a paginator object for paginating blogs.
    #
    # ==== Parameters
    # options<Hash>:: options used to qualify the pagination and blog selection
    #
    # ==== Options
    # :all => if it evaluates to TRUE, then both published and unpublished blogs
    #         will be paginated.  The default is for only published blogs to display
    # :per_page => Override the default setting for the number of blogs per page
    # _anything_else_ => will be fed as a parameter to Blog#all
    #
    # ==== Example
    #  @page = Blog.paginate_for( current_user ).page( params[:page] )
    def paginate( options = {} )
      pp  = options.delete(:per_page) || per_page
      all = options.delete(:all)

      options.delete(:category_id) if options[:category_id].nil?

      count = count_for( all, options[:category_id] )

      Paginator.new( count, per_page ) do |offset, per_page|
        all( default_options.merge(options).merge( :limit => pp, :offset => offset ) )
      end
    end

    private
      def default_options() { :order => 'published_at DESC' }; end

      def count_for( all, category_id = nil )
        conditions = category_id ? ['category_id = ?'] : [true]
        parameters = category_id ? [ category_id ]     : []

        unless all
          conditions << 'published_at IS NOT NULL'
        end

        conditions = [ conditions.join(' AND '), *parameters ].compact
        Blog.count( :conditions => conditions )
      end
  end

  # Returns a boolean indicating whether or not comments can be added to the blog
  def comments_closed?
    return false if self.comments_expire_at.nil?
    Date.today >= self.comments_expire_at.to_date
  end

  def comments_expire_at=( date )
    @comments_expire_at = parse_date( date )
  end

  alias published published_at

  def published=( value )
    if [0,'0',false,''].include?(value)
      self.published_at &&= nil
    else
      self.published_at ||= Time.now
    end
  end

  def published?
    !published_at.nil?
  end

  def preview( words = 35, paragraphs = 2 )
    words = body_without_markup.split(/ +/)[0...words].join(' ')
    paras = words.split(/[\n\r]+/)
    '<p>%s...</p>' % paras[0...paragraphs].join('</p><p>')
  end

  def count_comments
    Comment.count( :conditions => ['comments.blog_id = ?', self.id] )
  end

  private

    def set_path_title
      self.path_title ||= self.title.downcase.gsub(/[^a-zA-Z_0-9 ]+/, '').gsub(/ +/, '-')
    end

    def set_year()       self.year         = Time.now.year;  end
    def set_month()      self.month        = Time.now.month; end

    # Before saving, check to make sure that the category_id is set to an integer.
    # If not, create a new category with the title of teh category_id.
    def normalize_category_id
      return true if [nil,0].include?(self.category_id)
      if self.category_id.to_s =~ /[a-zA-Z]/
        category = Category.find_or_create( :title => self.category_id )
        self.category_id = category.id
      end
    end

    def cache_body_html
      return true if self.body.blank?
      self.body_html = formatted_body
    end

    def parse_date( date_params )
      return date_params unless date_params.is_a?( Hash )
      d = date_params
      Date.parse('%4d.%2d.%2d' % [d['year'],d['month'],d['day']])
    end

    def body_without_markup
      body_html.to_s.gsub(%r{<[^>]*>},'')
    end

    # From http://www.ruby-forum.com/topic/77231
    REGEX = /\[code.*?code\]/m
    Syntaxi::line_number_method = 'floating'
    Syntaxi::wrap_enabled = false

    # formattes the body using redcloth, colorizes ruby code using syntax(i)
    def formatted_body
      code_blocks = get_code_blocks(self.body)
      red_clothed = RedCloth.new(body.gsub(REGEX, '${code_block}')).to_html

      code_blocks.each { |c|
        c = Syntaxi.new(c).process
        red_clothed.sub!(/\$\{code_block\}/, c)
      }

      red_clothed
    end

    # retrieves code in [code][/code] blocks
    def get_code_blocks(contents)
      code_blocks = []
      code_block = contents.slice(REGEX)
      if (!code_block.nil?)
        code_blocks << code_block
        while code_block = $'.slice(REGEX)
          code_blocks << code_block
        end
      end
      code_blocks
    end
end