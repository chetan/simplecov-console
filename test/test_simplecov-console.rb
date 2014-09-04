require 'helper'

class TestSimplecovConsole < MiniTest::Test

  Source = Struct.new(:line_number)

  def setup
    @console = SimpleCov::Formatter::Console.new
  end

  def test_defined
    assert defined?(SimpleCov::Formatter::Console)
    assert defined?(SimpleCov::Formatter::Console::VERSION)
  end

  def test_missed
    missed_lines = [Source.new(1), Source.new(2),
                    Source.new(3), Source.new(5)]
    expected_result = ["1-3", "5"]
    assert_equal @console.missed(missed_lines), expected_result
  end
end
