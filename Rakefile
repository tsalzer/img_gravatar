# Rakefile for img_gravatar
require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('img_gravatar', '0.0.1') do |p|
  p.description = "Add a img_gravatar helper to ActiveView."
  p.url = "http://github.com/tsalzer/img_gravatar"
  p.author = "Till Salzer"
  p.email = "till.salzer@googlemail.com"
  p.ignore_pattern = ["tmp/*", "script/*", "rdoc/*", "pkg/*", "gravatar.tmproj"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
