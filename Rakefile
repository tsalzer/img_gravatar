require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "img_gravatar"
    gem.summary = %Q{Gravatar image helper}
    gem.description = %Q{Add a img_gravatar helper to ActiveView.}
    gem.email = "till.salzer@googlemail.com"
    gem.homepage = "http://github.com/tsalzer/img_gravatar"
    gem.authors = ["Till Salzer", "Jon Wood"]
    gem.add_dependency 'actionpack'
    gem.add_development_dependency 'cucumber', '>= 0.6.2'
    gem.add_development_dependency 'rspec', '>= 1.3.0'
    gem.add_development_dependency 'rcov', '>= 0.9.7'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end



task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'doc'
  rdoc.title = "img_gravatar #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('MIT-LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

