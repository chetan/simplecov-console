require 'helper'

class TestSimplecovConsole < MiniTest::Unit::TestCase
  def test_defined
    assert defined?(SimpleCov::Formatter::Console)
    assert defined?(SimpleCov::Formatter::Console::VERSION)
  end
end
