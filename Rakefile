require 'rake/clean'
require 'rake/testtask'
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rbconfig'

DLEXT = RbConfig::CONFIG["DLEXT"]
NATIVE_LIB = "lib/lzf_fast/native.#{DLEXT}"

directory 'target'
directory 'lib/lzf-fast'

task :cargo_build do
  sh "cargo build --release"
end
CLEAN.include('target')

file NATIVE_LIB => ['lib/lzf_fast', :cargo_build] do
  sh "cp target/release/liblzf_fast.#{DLEXT} #{NATIVE_LIB}"
end
CLOBBER.include(NATIVE_LIB)

task :irb => NATIVE_LIB do
  exec "irb -Ilib -rlzf_fast"
end

task :benchmark => NATIVE_LIB do
  exec "ruby -Ilib benchmark.rb"
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :test => NATIVE_LIB
task :default => :test

task :run => NATIVE_LIB do
  exec "ruby -Ilib -rlzf_fast run.rb"
end
