Gem::Specification.new do |s|
  s.name = %q{rubigen}
  s.version = "1.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dr Nic Williams", "Jeremy Kemper"]
  s.date = %q{2008-05-18}
  s.description = %q{A framework to allow Ruby applications to generate file/folder stubs (like the rails command does for Ruby on Rails, and the ‘script/generate’ command within a Rails application during development).}
  s.email = %q{drnicwilliams@gmail.com}
  s.executables = ["install_rubigen_scripts", "ruby_app"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "Todo.txt", "app_generators/ruby_app/templates/README.txt", "website/index.txt", "website/version-raw.txt", "website/version.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "Todo.txt", "app_generators/ruby_app/USAGE", "app_generators/ruby_app/ruby_app_generator.rb", "app_generators/ruby_app/templates/README.txt", "app_generators/ruby_app/templates/Rakefile", "app_generators/ruby_app/templates/lib/module.rb", "app_generators/ruby_app/templates/test/test_helper.rb.erb", "bin/install_rubigen_scripts", "bin/ruby_app", "config/hoe.rb", "config/requirements.rb", "generators/install_rubigen_scripts/install_rubigen_scripts_generator.rb", "generators/install_rubigen_scripts/templates/script/destroy", "generators/install_rubigen_scripts/templates/script/generate", "generators/install_rubigen_scripts/templates/script/win_script.cmd", "lib/rubigen.rb", "lib/rubigen/base.rb", "lib/rubigen/commands.rb", "lib/rubigen/generated_attribute.rb", "lib/rubigen/helpers/generator_test_helper.rb", "lib/rubigen/lookup.rb", "lib/rubigen/manifest.rb", "lib/rubigen/options.rb", "lib/rubigen/scripts.rb", "lib/rubigen/scripts/destroy.rb", "lib/rubigen/scripts/generate.rb", "lib/rubigen/scripts/update.rb", "lib/rubigen/simple_logger.rb", "lib/rubigen/spec.rb", "lib/rubigen/version.rb", "rubygems_generators/application_generator/USAGE", "rubygems_generators/application_generator/application_generator_generator.rb", "rubygems_generators/application_generator/templates/bin", "rubygems_generators/application_generator/templates/generator.rb", "rubygems_generators/application_generator/templates/readme", "rubygems_generators/application_generator/templates/test.rb", "rubygems_generators/application_generator/templates/test_generator_helper.rb", "rubygems_generators/application_generator/templates/usage", "rubygems_generators/component_generator/USAGE", "rubygems_generators/component_generator/component_generator_generator.rb", "rubygems_generators/component_generator/templates/generator.rb", "rubygems_generators/component_generator/templates/rails_generator.rb", "rubygems_generators/component_generator/templates/readme", "rubygems_generators/component_generator/templates/test.rb", "rubygems_generators/component_generator/templates/test_generator_helper.rb", "rubygems_generators/component_generator/templates/usage", "script/destroy", "script/generate", "script/txt2html", "script/txt2js", "setup.rb", "tasks/deployment.rake", "tasks/environment.rake", "tasks/website.rake", "test/examples_from_rails/generator_test_helper.rb", "test/examples_from_rails/test_rails_resource_generator.rb", "test/examples_from_rails/test_rails_scaffold_generator.rb", "test/test_application_generator_generator.rb", "test/test_component_generator_generator.rb", "test/test_generate_builtin_application.rb", "test/test_generate_builtin_test_unit.rb", "test/test_generator_helper.rb", "test/test_helper.rb", "test/test_install_rubigen_scripts_generator.rb", "test/test_lookup.rb", "test_unit_generators/test_unit/USAGE", "test_unit_generators/test_unit/templates/test.rb", "test_unit_generators/test_unit/test_unit_generator.rb", "website/index.html", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.js", "website/template.rhtml", "website/version-raw.js", "website/version-raw.txt", "website/version.js", "website/version.txt"]
  s.has_rdoc = true
  s.homepage = %q{http://rubigen.rubyforge.org}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rubigen}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A framework to allow Ruby applications to generate file/folder stubs (like the rails command does for Ruby on Rails, and the ‘script/generate’ command within a Rails application during development).}
  s.test_files = ["test/examples_from_rails/test_rails_resource_generator.rb", "test/examples_from_rails/test_rails_scaffold_generator.rb", "test/test_application_generator_generator.rb", "test/test_component_generator_generator.rb", "test/test_generate_builtin_application.rb", "test/test_generate_builtin_test_unit.rb", "test/test_generator_helper.rb", "test/test_helper.rb", "test/test_install_rubigen_scripts_generator.rb", "test/test_lookup.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<activesupport>, [">= 1.4.4"])
    else
      s.add_dependency(%q<activesupport>, [">= 1.4.4"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 1.4.4"])
  end
end
