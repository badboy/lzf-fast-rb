#!/usr/bin/env ruby
# encoding: utf-8

lorem = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."

def catch_it(data, meth=:compress)
  data = LZF.send(meth, *data)
  p [data.bytesize, data]
rescue RuntimeError => e
  p e
end

compressed = LZF::compress(lorem)
p [lorem.bytesize, compressed.bytesize, compressed]

catch_it("hello")
catch_it(["hello", 20], :decompress)

decompressed = LZF::decompress(compressed, lorem.bytesize)
p lorem == decompressed
p decompressed
