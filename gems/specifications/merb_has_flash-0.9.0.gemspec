Gem::Specification.new do |s|
  s.name = %q{merb_has_flash}
  s.version = "0.9.0"
  s.date = %q{2008-03-03}
  s.summary = %q{Merb plugin that provides a Rails-style flash}
  s.email = %q{ivey@gweezlebur.com}
  s.homepage = %q{http://merb-plugins.rubyforge.org/merb_has_flash/}
  s.description = %q{Merb plugin that provides a Rails-style flash}
  s.autorequire = %q{merb_has_flash}
  s.has_rdoc = true
  s.authors = ["Michael Ivey"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/merb_has_flash", "lib/merb_has_flash/controller_extension.rb", "lib/merb_has_flash/flash_hash.rb", "lib/merb_has_flash/helper.rb", "lib/merb_has_flash.rb"]
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.add_dependency(%q<merb-core>, [">= 0.9.0"])
end
