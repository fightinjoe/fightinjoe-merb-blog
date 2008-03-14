module Merb
  class Router
    class Behavior
      private
        # ==== Parameters
        # parent<Merb::Router::Behavior>::
        #   The parent behavior for the generated resource behaviors.
        #
        # ==== Returns
        # Array:: Behaviors for a RESTful resource.
        def resources_behaviors(parent = self)
          [
            Behavior.new({ :path => %r[^/?(\.:format)?$],           :method => :get },    { :action => "index" },   parent),
            Behavior.new({ :path => %r[^/index(\.:format)?$],       :method => :get },    { :action => "index" },   parent),
            Behavior.new({ :path => %r[^/new$],                     :method => :get },    { :action => "new" },     parent),
            Behavior.new({ :path => %r[^/new(\.:format)?$],         :method => :post },   { :action => "create" },  parent),
            Behavior.new({ :path => %r[^/:id(\.:format)?$],         :method => :get },    { :action => "show" },    parent),
            Behavior.new({ :path => %r[^/:id[;/]edit$],             :method => :get },    { :action => "edit" },    parent),
            Behavior.new({ :path => %r[^/:id[;/]edit(\.:format)?$], :method => :put },    { :action => "update" },  parent),
            Behavior.new({ :path => %r[^/:id[;/]delete$],           :method => :get },    { :action => "delete" },  parent),
            Behavior.new({ :path => %r[^/:id(\.:format)?$],         :method => :delete }, { :action => "destroy" }, parent)
          ]
        end

        # ==== Parameters
        # parent<Merb::Router::Behavior>::
        #   The parent behavior for the generated resource behaviors.
        #
        # ==== Returns
        # Array:: Behaviors for a singular RESTful resource.
        def resource_behaviors(parent = self)
          [
            Behavior.new({ :path => %r{^[;/]new$},              :method => :get },    { :action => "new" },     parent),
            Behavior.new({ :path => %r{^[;/]new(\.:format)?$},  :method => :post },   { :action => "create" },  parent),
            Behavior.new({ :path => %r{^/?(\.:format)?$},       :method => :get },    { :action => "show" },    parent),
            Behavior.new({ :path => %r{^[;/]edit$},             :method => :get },    { :action => "edit" },    parent),
            Behavior.new({ :path => %r{^[;/]edit(\.:format)?$}, :method => :put },    { :action => "update" },  parent),
            Behavior.new({ :path => %r{^[;/]delete$},           :method => :get },    { :action => "delete" },    parent),
            Behavior.new({ :path => %r{^/?(\.:format)?$},       :method => :delete }, { :action => "destroy" }, parent)
          ]
        end
    end
  end
end