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
  if DLEXT == "bundle"
    sh "sed -i.bak 's/cdylib/staticlib/' Cargo.toml"
  end
  sh "cargo build --release"
end
CLEAN.include('target')

if DLEXT == "bundle"
  file NATIVE_LIB => ['lib/lzf_fast', :cargo_build] do
    sh "gcc -Wl,-force_load,target/release/liblzf_fast.a --shared -Wl,-undefined,dynamic_lookup -o #{NATIVE_LIB}"
  end
else
file NATIVE_LIB => ['lib/lzf_fast', :cargo_build] do
  sh "cp target/release/liblzf_fast.#{DLEXT} #{NATIVE_LIB}"
end
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
