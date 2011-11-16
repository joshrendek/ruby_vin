require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('ruby_vin', '0.1.0') do |p|
  p.description "Get VIN information from manufacturers"
  p.url "http://github.com/bluescripts/ruby_vin"
  p.author = "Josh Rendek"
  p.email = "josh@bluescripts.net"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

