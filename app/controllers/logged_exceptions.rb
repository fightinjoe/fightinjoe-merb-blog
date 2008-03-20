require File.join(File.dirname(__FILE__), '..', '..', "lib", "authenticated_system", "authenticated_dependencies")

class LoggedExceptions < Application
  def index
    @exception_names    = LoggedException.find_exception_class_names
    @controller_actions = LoggedException.find_exception_controllers_and_actions
    query
  end

  def query
    conditions = []
    parameters = []
    unless params[:id].blank?
      conditions << 'id = ?'
      parameters << params[:id]
    end
    unless params[:query].blank?
      conditions << 'message LIKE ?'
      parameters << "%#{params[:query]}%"
    end
    unless params[:date_ranges_filter].blank?
      conditions << 'created_at >= ?'
      parameters << params[:date_ranges_filter].to_f.days.ago.utc
    end
    unless params[:exception_names_filter].blank?
      conditions << 'exception_class = ?'
      parameters << params[:exception_names_filter]
    end
    unless params[:controller_actions_filter].blank?
      conditions << 'controller_name = ? AND action_name = ?'
      parameters += params[:controller_actions_filter].split('/').collect(&:downcase)
    end
    @exceptions = LoggedException.paginate( conditions.empty? ? nil : parameters.unshift(conditions * ' and ') )

    render :layout => false
#    respond_to do |format|
#      format.html { redirect_to :action => 'index' unless action_name == 'index' }
#      format.js
#      format.rss  { render :action => 'query.rxml' }
#    end
  end

  def show
    provides :html, :js
    @exc = LoggedException.get( params[:id] )
    render
  end

  def destroy
    LoggedException.destroy( params[:id] )
  end

  def destroy_all
    provides :js
    unless params[:ids].blank?
      ids = params[:ids].split(',').collect(&:to_i)
      LoggedException.all( :conditions => ['id in ?', ids] ).each { |l| l.destroy! }
    end
    query
  end

  private
    def access_denied_with_basic_auth
      headers["Status"]           = "Unauthorized"
      headers["WWW-Authenticate"] = %(Basic realm="Web Password")
      render :text => "Could't authenticate you", :status => '401 Unauthorized'
    end
end