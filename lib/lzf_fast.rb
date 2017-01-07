require 'fiddle'
require 'rbconfig'

dlext = RbConfig::CONFIG["DLEXT"]
native_lib = "lzf_fast/native.#{dlext}"

dirname = File.dirname(__FILE__)
library = Fiddle::dlopen(File.join(dirname, native_lib))
Fiddle::Function.new(library['initialize_lzf'], [], Fiddle::TYPE_VOIDP).call
