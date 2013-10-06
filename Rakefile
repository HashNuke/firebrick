require 'sprockets'
require 'rake/sprocketstask'

task :assets do
  sprockets = Sprockets::Environment.new("./") do |env|
    env.logger = Logger.new(STDOUT)
    env.append_path 'assets/javascripts'
    env.append_path 'assets/stylesheets'
  end

  assets = %w( application.js application.css )
  output = "./priv/static/assets"

  assets.each do |asset|
    puts asset
    puts sprockets[asset]
    sprockets[asset].write_to "#{output}/#{asset}"
  end
end
