require "minitest/autorun"
require_relative "test_methods"
require_relative "../text_parser"

class TestTextParser < MiniTest::Unit::TestCase
  attr_reader :parse_test
  def setup
    test_file = 'spec/data.txt'
    @parse_test = TextParser.new(test_file)
  end

  def test_getting_initial_value_of_file
    assert_equal "I meant 'moderately,' not 'tediously,' above.", parse_test.get_item('meta data', 'correction text')
    assert_equal 205, parse_test.get_item('header', 'accessed')
    assert_equal 4.5, parse_test.get_item('header', 'budget') 
  end

  def test_retrieving_new_additions_to_file
    parse_test.add_value('priorities', 'mindset', 'constant learner')
    parse_test.add_value('priorities', 'attitude', 'can do')
    parse_test.add_value('extra priorities data', 'mindset degree of awesome', '10.01')
    assert_equal 'constant learner', parse_test.get_item('priorities', 'mindset')
    assert_equal 'can do', parse_test.get_item('priorities', 'attitude') 
    assert_equal 10.01, parse_test.get_item('extra priorities data', 'mindset degree of awesome')
  end

  def test_retrieving_values_in_different_formant_than_saved
    assert_equal 4, parse_test.get_item('header', 'budget', 'integer')
    assert_equal 205, parse_test.get_item('header', 'accessed', 'float')
    assert_equal '205', parse_test.get_item('header', 'accessed', 'string')
    assert_equal 0, parse_test.get_item('priorities', 'mindset', 'integer')
    assert_equal 0.0, parse_test.get_item('priorities', 'mindset', 'float')
  end

  def test_overwrite_feature
    parse_test.add_value('priorities', 'mindset', 'oompa loompa', true)
    parse_test.add_value('priorities', 'mindset', 'stranger in a strange land')
    assert_equal 'oompa loompa', parse_test.get_item('priorities', 'mindset')
  end

  def teardown
    reset_test_data(test_file)
  end
end