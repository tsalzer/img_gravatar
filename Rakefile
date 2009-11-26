require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "img_gravatar"
    gem.summary = %Q{Gravatar image helper}
    gem.description = %Q{Add a img_gravatar helper to ActiveView.}
    gem.email = "till.salzer@googlemail.com"
    gem.homepage = "http://github.com/tsalzer/minimapper"
    gem.authors = ["Till Salzer"]
    gem.add_development_dependency 'rspec', '>= 1.2.9'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
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

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "img_gravatar #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

