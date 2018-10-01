# encoding: UTF-8
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

# Load dummy app tasks
APP_RAKEFILE = File.expand_path('spec/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'Start development web server'
task :dev do
  host = '0.0.0.0'
  port = ENV['PORT'] || 9292
  ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'development'
  Dir.chdir 'spec/dummy'

  Rack::Server.start(
      environment: 'development',
      Host: host,
      Port: port,
      config: 'config.ru'
  )
end

desc 'Test all Gemfiles from spec/*.gemfile'
task :test_all_gemfiles do
  require 'pty'
  require 'shellwords'
  cmd      = 'bundle install --quiet && bundle exec rake --trace'
  statuses = Dir.glob('./spec/gemfiles/*{[!.lock]}').map do |gemfile|
    Bundler.with_clean_env do
      env = {'BUNDLE_GEMFILE' => gemfile}
      $stderr.puts "Testing #{File.basename(gemfile)}:\n  export #{env.map { |k, v| "#{k}=#{Shellwords.escape v}" } * ' '}; #{cmd}"
      PTY.spawn(env, cmd) do |r, _w, pid|
        begin
          r.each_line { |l| puts l }
        rescue Errno::EIO
          # Errno:EIO error means that the process has finished giving output.
        ensure
          ::Process.wait pid
        end
      end
      [$? && $?.exitstatus == 0, gemfile]
    end
  end
  failed_gemfiles = statuses.reject(&:first).map { |(_status, gemfile)| gemfile }
  if failed_gemfiles.empty?
    $stderr.puts "✓ Tests pass with all #{statuses.size} gemfiles"
  else
    $stderr.puts "❌ FAILING (#{failed_gemfiles.size} / #{statuses.size})\n#{failed_gemfiles * "\n"}"
    exit 1
  end
end
