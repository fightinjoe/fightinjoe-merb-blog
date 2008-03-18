class LoggedException < DataMapper::Base
  property :exception_class, :string
  property :controller_name, :string
  property :action_name,     :string
  property :message,         :text
  property :backtrace,       :text
  property :cookies,         :text
  property :session,         :text
  property :params,          :text
  property :environment,     :string
  property :request,         :text
  property :created_at,      :datetime

  ### Class Methods ###

  def self.create_from_controller( controller )
    e_params, request = controller.params, controller.request

    params = {}
    params[:controller], params[:action] = e_params[:original_params][:controller], e_params[:original_params][:action]
    for key in [:cookies, :sessions, :params]
      params[key] = params[ "original_#{ key }" ]
    end
    params[:exception] = e_params[:exception]
    params[:request]   = request

    self.create( params )
  end

  def self.find_exception_class_names
    find_by_sql( 'SELECT DISTINCT exception_class FROM logged_exceptions;' )
  end

  def self.find_exception_controllers_and_actions
    sql = 'SELECT DISTINCT controller_name, action_name FROM logged_exceptions;'
    find_by_sql(sql).collect{ |c,a| "#{c.to_s.camel_case}/#{a}"}
  end

  # Pagination

  def self.per_page() 20; end

  def self.paginate( conditions )
    Paginator.new( count( :conditions => conditions ), per_page ) do |offset, per_page|
      all( :conditions => conditions, :limit => per_page, :offset => offset, :order => 'created_at desc' )
    end
  end

  ### Instance Methods ###

  def cookies
    @cookie_cache ||= @cookies && YAML.load( @cookies )
  end

  def cookies=( hash )
    @cookie_cache = hash
    @cookies = hash.to_yaml
  end

  def exception=( e )
    exception_class = e.class.name
    message         = e.message
    backtrace       = e.backtrace.to_yaml
  end

  def params
    @params_cache ||= @params && YAML.load( @params )
  end

  def params=( hash )
    @params_cache = hash
    @params = hash.to_yaml
  end

  def session
    @session_cache ||= @session && YAML.load( @session )
  end

  def session=( hash )
    @session_cache = hash
    @session = hash.to_yaml
  end

  def request=( req )
    env = req.env
    #environment = env << "* Process: #{$$}" << "* Server : #{self.class.host_name}") * "\n")
  end

  def controller_action
    '%s/%s' % [ controller_name.to_s.camel_case, action_name ]
  end
end