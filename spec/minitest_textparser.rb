gem "minitest"
require "minitest/autorun"
require_relative "test_methods"
require_relative "../text_parser"

class TestTextParser < MiniTest::Test
  attr_reader :parse_test, :file
  def setup
    @file = 'spec/data.txt'
    create_test_data(file)
    @parse_test = TextParser.new(file + "1")
  end

  def test_getting_initial_value_of_file
    assert_equal "This is a tediously long description of the Lonely Planet programming test that you are taking. Tedious isn't the right word, but it's the first word that comes to mind. Perhaps the word we're looking for is: slightly?", parse_test.get_item('meta data', 'description')
    assert_equal "I meant 'moderately,' not 'tediously,' above.", parse_test.get_item('meta data', 'correction text')
    assert_equal 205, parse_test.get_item('header', 'accessed')
    assert_equal 4.5, parse_test.get_item('header', 'budget') 
  end

  def test_retrieving_new_additions_to_file
    parse_test.add_value('priorities', 'mindset', 'constant learner')
    parse_test.add_value('priorities', 'attitude', 'can do')
    parse_test.add_value('extra priorities data', 'mindset degree of awesome', '10.01')
    parse_test.add_value('header', 'final thought', 'tests make things not break; who does not like that?')
    assert_equal 'constant learner', parse_test.get_item('priorities', 'mindset')
    assert_equal 'can do', parse_test.get_item('priorities', 'attitude') 
    assert_equal 'tests make things not break; who does not like that?', parse_test.get_item('header', 'final thought')
    assert_equal 10.01, parse_test.get_item('extra priorities data', 'mindset degree of awesome')
  end

  def test_retrieving_values_in_different_format_than_saved
    assert_equal 4, parse_test.get_item('header', 'budget', 'integer')
    assert_equal 205, parse_test.get_item('header', 'accessed', 'float')
    assert_equal '205', parse_test.get_item('header', 'accessed', 'string')
  end

  def test_overwrite_feature
    parse_test.add_value('priorities', 'mindset', 'oompa loompa', true)
    parse_test.add_value('priorities', 'mindset', 'stranger in a strange land')
    assert_equal 'oompa loompa', parse_test.get_item('priorities', 'mindset')
  end

  def after
    create_test_data(file)
  end
end