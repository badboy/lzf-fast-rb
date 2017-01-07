require 'rake/clean'
require 'rake/testtask'
require 'bundler/setup'
require 'bundler/gem_tasks'

directory 'target'
directory 'lib/lzf-fast'

task :cargo_build do
  sh "cargo build --release"
end
CLEAN.include('target')

file "lib/lzf_fast/native.so" => ['lib/lzf_fast', :cargo_build] do
  sh "cp target/release/liblzf_fast.so lib/lzf_fast/native.so"
end
CLOBBER.include('lib/lzf_fast/native.so')

task :irb => "lib/lzf_fast/native.so" do
  exec "irb -Ilib -rlzf_fast"
end

task :benchmark => "lib/lzf_fast/native.so" do
  exec "ruby -Ilib benchmark.rb"
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :test => "lib/lzf_fast/native.so"
task :default => :test

task :run => "lib/lzf_fast/native.so" do
  exec "ruby -Ilib -rlzf_fast run.rb"
end
