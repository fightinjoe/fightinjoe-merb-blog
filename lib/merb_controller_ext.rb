# Extensions to Merb's Application controller that need to be loaded
# after other extensions (e.g. authenticated_system_controller) - to
# be required within the after_app_loads block of init.rb
class Application < Merb::Controller
  protected
    alias orig_access_denied access_denied

    def access_denied
      case content_type
      when :rss
        headers["Status"]             = "Unauthorized"
        headers["WWW-Authenticate"]   = %(Basic realm="Web Password")
        self.status = 401

        @title       = 'Fightinjoe: 406 Not Authorized'
        @link        = 'http://www.fightinjoe.com'
        @description = 'You are not authorized to view this content.'

        render "<item><title>Couldn't authenticate you</title></item>"
      else
        orig_access_denied
      end
    end
end
