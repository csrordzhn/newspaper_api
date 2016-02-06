Dir.glob('./{models,helpers,controllers}/*.rb').each { |file| require file }

require 'rake/testtask'

task :default => :spec

desc 'Run all tests'

Rake::TestTask.new(name = :spec) do |t|
   t.pattern = 'spec/api_specs.rb'
end
