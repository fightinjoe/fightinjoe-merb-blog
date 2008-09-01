Gem::Specification.new do |s|
  s.name = %q{do_postgres}
  s.version = "0.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yehuda Katz"]
  s.date = %q{2008-06-25}
  s.description = %q{A DataObject.rb driver for PostgreSQL}
  s.email = %q{wycats@gmail.com}
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["ext/do_postgres_ext.c", "ext/type-oids.h", "ext/extconf.rb", "lib/do_postgres/transaction.rb", "lib/do_postgres.rb", "spec/integration/do_postgres_spec.rb", "spec/integration/logging_spec.rb", "spec/integration/quoting_spec.rb", "spec/integration/timezone_spec.rb", "spec/spec_helper.rb", "spec/unit/transaction_spec.rb", "Rakefile", "README", "LICENSE", "TODO"]
  s.has_rdoc = true
  s.homepage = %q{http://rubyforge.org/projects/dorb}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{dorb}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A DataObject.rb driver for PostgreSQL}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<data_objects>, ["= 0.9.2"])
    else
      s.add_dependency(%q<data_objects>, ["= 0.9.2"])
    end
  else
    s.add_dependency(%q<data_objects>, ["= 0.9.2"])
  end
end
