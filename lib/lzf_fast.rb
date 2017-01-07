require 'fiddle'

dirname = File.dirname(__FILE__)
library = Fiddle::dlopen(File.join(dirname, '/lzf_fast/native.so'))
Fiddle::Function.new(library['initialize_lzf'], [], Fiddle::TYPE_VOIDP).call
