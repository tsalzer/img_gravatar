# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{img_gravatar}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Till Salzer"]
  s.date = %q{2009-01-20}
  s.description = %q{Add a img_gravatar helper to ActiveView.}
  s.email = %q{till.salzer@googlemail.com}
  s.extra_rdoc_files = ["lib/img_gravatar.rb", "README.rdoc", "tasks/img_gravatar_tasks.rake"]
  s.files = ["img_gravatar.gemspec", "init.rb", "install.rb", "lib/img_gravatar.rb", "Manifest", "Rakefile", "README.rdoc", "tasks/img_gravatar_tasks.rake", "test/img_gravatar_test.rb", "uninstall.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/tsalzer/img_gravatar}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Img_gravatar", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{img_gravatar}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Add a img_gravatar helper to ActiveView.}
  s.test_files = ["test/img_gravatar_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
