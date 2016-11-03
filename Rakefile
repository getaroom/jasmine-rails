require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'appraisal'
require 'combustion'

RuboCop::RakeTask.new(:rubocop)

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.fork = true
  t.cucumber_opts = ['--format', (ENV['CUCUMBER_FORMAT'] || 'progress')]
end

RSpec::Core::RakeTask.new(:spec)

desc 'Run the test suite'
task :default do
  if ENV['BUNDLE_GEMFILE'] =~ /gemfiles/
    exec 'rake test'
  else
    Rake::Task['appraise'].execute
  end
end

task :appraise => ['appraisal:install'] do
  exec 'rake appraisal'
end

task test: [:rubocop, :spec, :cucumber]
