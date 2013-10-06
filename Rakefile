require 'sprockets'
require 'rake/sprocketstask'



# assets = Sprockets::Environment.new(project_root) do |env|
#   env.logger = Logger.new(STDOUT)
# end
# 
# assets.append_path 'assets/javascripts'
# assets.append_path 'assets/stylesheets'

Rake::SprocketsTask.new do |t|
  t.environment = Sprockets::Environment.new

  t.environment.append_path 'assets/javascripts'
  t.environment.append_path 'assets/stylesheets'
  t.environment.logger = Logger.new(STDOUT)
  t.output      = "./priv/static/assets"
  t.assets      = %w( application.js application.css )
end
