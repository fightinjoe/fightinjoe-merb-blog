require 'datamapper_ext'
class LoggedException < DataMapper::Base
  include DataMapperExt

  property :exception_class, :string
  property :controller_name, :string
  property :action_name,     :string
  property :message,         :text
  property :backtrace,       :text
  property :cookies,         :text
  property :session,         :text
  property :params,          :text
  property :environment,     :text
  property :url,             :text
  property :created_at,      :datetime

  yaml_attribute :cookies, :backtrace, :params, :session, :environment, :request

  ### Class Methods ###

  def self.create_from_controller( controller )
    e_params, request = controller.params, controller.request
    params = {}
    params[:controller_name], params[:action_name] = e_params[:original_params][:controller], e_params[:original_params][:action]
    params[:params]    = e_params[ "original_params" ]
    params[:session]   = controller.session.data
    params[:exception] = e_params[:exception]
    self.create( params )
  end

  def self.find_exception_class_names
    find_by_sql( 'SELECT DISTINCT exception_class FROM logged_exceptions;' )
  end

  def self.find_exception_controllers_and_actions
    sql = 'SELECT DISTINCT controller_name, action_name FROM logged_exceptions;'
    find_by_sql(sql).collect{ |c,a| "#{c.to_s.camel_case}/#{a}"}
  end

  # Pagination support

  def self.per_page() 20; end

  def self.paginate( conditions )
    Paginator.new( count( :conditions => conditions ), per_page ) do |offset, per_page|
      all( :conditions => conditions, :limit => per_page, :offset => offset, :order => 'created_at desc' )
    end
  end

  ### Instance Methods ###

  def exception=( e )
    self.exception_class = e.name
    self.message         = e.message
    self.backtrace       = e.backtrace
  end

  def request=( req )
    self.environment = req.env.merge( 'process' => $$ )
    self.url         = "#{req.protocol}#{req.env["HTTP_HOST"]}#{req.uri}"
    #environment = env << "* Process: #{$$}" << "* Server : #{self.class.host_name}") * "\n")
  end

  def controller_action
    '%s/%s' % [ controller_name.to_s.camel_case, action_name ]
  end

end