require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'reek/rake/task'
require_relative './lib/game'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new
Reek::Rake::Task.new

task default: %i[reek rubocop spec]

task :play do
  Game.new.run
end
