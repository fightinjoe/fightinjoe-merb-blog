Gem::Specification.new do |s|
  s.name = %q{merb-cache}
  s.version = "0.9.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Boussinet"]
  s.autorequire = %q{merb-cache}
  s.date = %q{2008-05-04}
  s.description = %q{Merb plugin that provides caching (page, action, fragment, object)}
  s.email = %q{alex.boussinet@gmail.com}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/merb-cache", "lib/merb-cache/cache-action.rb", "lib/merb-cache/cache-fragment.rb", "lib/merb-cache/cache-page.rb", "lib/merb-cache/cache-store", "lib/merb-cache/cache-store/database-activerecord.rb", "lib/merb-cache/cache-store/database-datamapper.rb", "lib/merb-cache/cache-store/database-sequel.rb", "lib/merb-cache/cache-store/database.rb", "lib/merb-cache/cache-store/dummy.rb", "lib/merb-cache/cache-store/file.rb", "lib/merb-cache/cache-store/memcache.rb", "lib/merb-cache/cache-store/memory.rb", "lib/merb-cache/merb-cache.rb", "lib/merb-cache/merbtasks.rb", "lib/merb-cache.rb", "spec/config", "spec/config/database.yml", "spec/controller.rb", "spec/merb-cache-action_spec.rb", "spec/merb-cache-fragment_spec.rb", "spec/merb-cache-page_spec.rb", "spec/merb-cache_spec.rb", "spec/spec_helper.rb", "spec/views", "spec/views/cache_controller", "spec/views/cache_controller/action1.html.erb", "spec/views/cache_controller/action2.html.haml"]
  s.has_rdoc = true
  s.homepage = %q{http://www.merbivore.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Merb plugin that provides caching (page, action, fragment, object)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<merb-core>, [">= 0.9.3"])
    else
      s.add_dependency(%q<merb-core>, [">= 0.9.3"])
    end
  else
    s.add_dependency(%q<merb-core>, [">= 0.9.3"])
  end
end
