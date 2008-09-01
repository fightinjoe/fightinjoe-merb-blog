Gem::Specification.new do |s|
  s.name = %q{merb-mailer}
  s.version = "0.9.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yehuda Katz"]
  s.autorequire = %q{merb-mailer}
  s.date = %q{2008-05-04}
  s.description = %q{Merb plugin that provides mailer functionality to Merb}
  s.email = %q{wycats@gmail.com}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/merb-mailer", "lib/merb-mailer/mail_controller.rb", "lib/merb-mailer/mailer.rb", "lib/merb-mailer/merb_controller.rb", "lib/merb-mailer.rb", "spec/mail_controller_spec.rb", "spec/mailer_spec.rb", "spec/mailers", "spec/mailers/views", "spec/mailers/views/layout", "spec/mailers/views/layout/application.html.erb", "spec/mailers/views/layout/application.text.erb", "spec/mailers/views/test_mail_controller", "spec/mailers/views/test_mail_controller/eighth.html.erb", "spec/mailers/views/test_mail_controller/eighth.text.erb", "spec/mailers/views/test_mail_controller/first.html.erb", "spec/mailers/views/test_mail_controller/first.text.erb", "spec/mailers/views/test_mail_controller/ninth.html.erb", "spec/mailers/views/test_mail_controller/ninth.text.erb", "spec/mailers/views/test_mail_controller/second.text.erb", "spec/mailers/views/test_mail_controller/third.html.erb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://merb-plugins.rubyforge.org/merb-mailer/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Merb plugin that provides mailer functionality to Merb}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<merb-core>, [">= 0.9.3"])
      s.add_runtime_dependency(%q<mailfactory>, [">= 1.2.3"])
    else
      s.add_dependency(%q<merb-core>, [">= 0.9.3"])
      s.add_dependency(%q<mailfactory>, [">= 1.2.3"])
    end
  else
    s.add_dependency(%q<merb-core>, [">= 0.9.3"])
    s.add_dependency(%q<mailfactory>, [">= 1.2.3"])
  end
end
