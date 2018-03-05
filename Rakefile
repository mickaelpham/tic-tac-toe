begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  require 'reek/rake/task'
  Reek::Rake::Task.new

  task default: %i[reek rubocop spec]
rescue LoadError
end

require_relative './lib/game'
task :play do
  Game.new.run
end
