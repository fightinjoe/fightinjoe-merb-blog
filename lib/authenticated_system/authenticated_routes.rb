# Put the correct routes in place
module AuthenticatedSystem
  def self.add_routes
    Merb::BootLoader.after_app_loads do
      Merb::Router.prepend do
        match("/login").to(:controller => "Sessions", :action => "create").name(:login)
        match("/logout").to(:controller => "Sessions", :action => "destroy").name(:logout)
        resources :users
        resources :sessions
      end
    end
  end
end