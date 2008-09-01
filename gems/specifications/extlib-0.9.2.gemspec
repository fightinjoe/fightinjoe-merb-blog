Gem::Specification.new do |s|
  s.name = %q{extlib}
  s.version = "0.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sam Smoot"]
  s.date = %q{2008-06-25}
  s.description = %q{Conveniences}
  s.email = %q{ssmoot@gmail.com}
  s.files = ["README", "lib/extlib/assertions.rb", "lib/extlib/blank.rb", "lib/extlib/hook.rb", "lib/extlib/inflection.rb", "lib/extlib/lazy_array.rb", "lib/extlib/module.rb", "lib/extlib/object.rb", "lib/extlib/pathname.rb", "lib/extlib/pooling.rb", "lib/extlib/string.rb", "lib/extlib/struct.rb", "lib/extlib.rb", "spec/blank_spec.rb", "spec/hook_spec.rb", "spec/inflection_spec.rb", "spec/lazy_array_spec.rb", "spec/module_spec.rb", "spec/object_spec.rb", "spec/pooling_spec.rb", "spec/spec_helper.rb", "spec/string_spec.rb", "spec/struct_spec.rb"]
  s.homepage = %q{http://extlib.rubyforge.org}
  s.require_paths = ["lib"]
  s.requirements = ["none"]
  s.rubyforge_project = %q{extlib}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Support Library}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<english>, [">= 0.2.0"])
      s.add_runtime_dependency(%q<rspec>, [">= 1.1.3"])
    else
      s.add_dependency(%q<english>, [">= 0.2.0"])
      s.add_dependency(%q<rspec>, [">= 1.1.3"])
    end
  else
    s.add_dependency(%q<english>, [">= 0.2.0"])
    s.add_dependency(%q<rspec>, [">= 1.1.3"])
  end
end
