Gem::Specification.new do |s|
  s.name = %q{merb-assets}
  s.version = "0.9.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ezra Zygmuntowicz"]
  s.autorequire = %q{merb-assets}
  s.date = %q{2008-05-04}
  s.description = %q{Merb plugin that provides the helpers for assets and asset bundling}
  s.email = %q{ez@engineyard.com}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/merb-assets", "lib/merb-assets/assets.rb", "lib/merb-assets/assets_mixin.rb", "lib/merb-assets.rb", "spec/merb-assets_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://merb-plugins.rubyforge.org/merb-assets/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Merb plugin that provides the helpers for assets and asset bundling}

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
