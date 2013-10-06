require 'sprockets'
require 'rake/sprocketstask'
require 'filewatcher'


sprockets = Sprockets::Environment.new("./") do |env|
  env.logger = Logger.new(STDOUT)
  env.append_path 'assets/javascripts'
  env.append_path 'assets/stylesheets'
end

assets = %w( application.js application.css )
asset_output = "priv/static/assets"


namespace :assets do

  desc "Compile assets"
  task :compile do
    assets.each do |asset|
      sprockets[asset].write_to "#{asset_output}/#{asset}"
    end
  end

  
  desc "Watch assets for changes and compile"
  task :watch do
    watch_list = ["assets/javascripts/", "assets/stylesheets"]

    FileWatcher.new(watch_list, "Watching assets for compliation...").watch do |filename|
      assets.each do |asset|
        puts asset
        sprockets[asset].write_to "#{asset_output}/#{asset}"
      end
    end
  end

end
