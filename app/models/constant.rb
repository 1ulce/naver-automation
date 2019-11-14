require 'settingslogic'
class Constant < Settingslogic
  if defined?(Rails)
    source "#{Rails.root}/config/constants.yml"
    namespace Rails.env
  else
    file_path = Pathname.new(Dir.pwd).join("config/constants.yml")
    if File.exist?(file_path)
      source file_path
      namespace "production"
    else
      raise "current directory was wrong. #{file_path} should exists."
    end
  end
end
