require 'fileutils'
module SaveScreenshots
  def screenshot!(name)
    return unless [:selenium, :webkit, :poltergeist].include?(Capybara.current_driver)
    dir = File.expand_path('../screenshots', File.dirname(__FILE__))
    name = "#{name}.png" unless name =~ /\.png$/
    FileUtils.mkpath(dir) unless File.directory?(dir)
    puts "saving screenshot: #{name}"
    save_screenshot File.join(dir, name), full: true
  end
end
