require 'rspec/core/rake_task'

task :feature_tests do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/features/*'
  end
  Rake::Task["spec"].execute
end

task :unit_tests do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/unit/*'
  end
  Rake::Task["spec"].execute
end