# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   match("/books/:book_id/:action").
#     to(:controller => "books")
#   
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can specify conditions on the placeholder by passing a hash as the second
# argument of "match"
#
#   match("/registration/:course_name", :course_name => /^[a-z]{3,5}-\d{5}$/).
#     to(:controller => "registration")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  match("/login").to(:controller => "Sessions", :action => "create").name(:login)
  match("/logout").to(:controller => "Sessions", :action => "destroy").name(:logout)
  resources :users
  resources :sessions

  namespace :admin do |admin|
    resources :blogs
  end

  # RESTful routes
  resources :blogs do |b|
    resources :comments
  end

  resources :comments
  
  match(%r{/(\d+)/(\d+)/([a-zA-Z\-]+)}).to(
    :controller => 'blogs', :action => 'show', :year => "[1]", :month => "[2]", :path_title => "[3]"
  )
  
  # NAMED routes
  match('/contact').to( :controller => 'comments', :action => 'new' ).name( :contact )
  
  match('/:category_title').to( :controller => 'blogs', :action => 'index' ).name( :category )
  # resources :posts

  # This is the default route for /:controller/:action/:id
  # This is fine for most cases.  If you're heavily using resource-based
  # routes, you may want to comment/remove this line to prevent
  # clients from calling your create or destroy actions with a GET
  default_routes

  # Used for path generation
  match('/:year/:month/:path_title').to( :controller => 'blogs', :action => 'show' ).name( :blog_by_date )

  # Change this for your home page to be available at /
  match('/').to(:controller => 'blogs', :action =>'show', :id => 'latest' )
end