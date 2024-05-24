Warbler::Config.new do |config|
  config.dirs = %w(lib)
  config.includes = FileList["lib/ship_smart.rb"]
  config.java_libs += FileList["lib/*.jar"]
  config.gems["prawn"] = "2.4.0"
  config.gems["csv"] = "3.3.0"
  config.gems["warbler"] = "2.0.5"
  config.executable = "lib/ship_smart.rb"
end