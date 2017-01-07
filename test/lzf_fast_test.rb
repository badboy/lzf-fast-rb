require 'test_helper'

class LzfFastTest < Minitest::Test
  LOREM = <<-EOF.tr("\n", ' ')
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren,
no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit
amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut
labore et dolore magna aliquyam erat, sed diam voluptua.
  EOF

  def test_compresses
    compressed = LZF::compress(LOREM)
    assert_equal 272, compressed.bytesize
  end

  def test_skips_short
    assert_raises(RuntimeError) do
      LZF::compress("foo")
    end
  end

  def test_lorem_round
    compressed = LZF::compress(LOREM)
    decompressed = LZF::decompress(compressed, LOREM.bytesize)

    assert_equal(LOREM, decompressed)
  end
end
