require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = Dir['test/*.rb'].select { |file| file =~ /\d{2}\-test./ }
end

desc "Run tests"
task :default => :test