require 'minitest/autorun'
require 'rspec/mocks'

require_relative '../../app.rb'

class TestTest < Minitest::Test

  include RSpec::Mocks::ExampleMethods

  def test_equals_with_integer_and_string

    test = Sprat::Test.new(1,[],[])

    expected_value = "23"
    actual_value = 23

    assert test.is_equal(expected_value, actual_value)
  end

  def test_equals_with_integer_strings

    test = Sprat::Test.new(1,[],[])

    expected_value = "23"
    actual_value = "23"
    assert test.is_equal(expected_value, actual_value)
  end

  def test_equals_with_numbers

    test = Sprat::Test.new(1,[],[])

    expected_value = 6.78
    actual_value = 6.78
    assert test.is_equal(expected_value, actual_value)
  end

  def test_equals_with_string_and_number

    test = Sprat::Test.new(1,[],[])

    expected_value = "6.78"
    actual_value = 6.78
    assert test.is_equal(expected_value, actual_value)
  end

  def test_equals_with_strings

    test = Sprat::Test.new(1,[],[])

    expected_value = "hello"
    actual_value = "hello"
    assert test.is_equal(expected_value, actual_value)

    expected_value = "one, two, three"
    actual_value = "one, two, three"
    assert test.is_equal(expected_value, actual_value)
  end

  def test_equals_with_strings_ignores_whitespace

    test = Sprat::Test.new(1,[],[])

    expected_value = "hello, matey"
    actual_value = "    hello  \r\n    ,  matey "
    assert test.is_equal(expected_value, actual_value)
  end

  def test_equals_with_arrays

    test = Sprat::Test.new(1,[],[])

    expected_value = "hello"
    actual_value = ["hello"]
    assert test.is_equal(expected_value, actual_value), "Expected #{expected_value} to equal #{actual_value}"

    expected_value = "one,    two,   three"
    actual_value = ["one", "two", "three"]
    assert test.is_equal(expected_value, actual_value), "Expected #{expected_value} to equal #{actual_value}"

    expected_value = "one,two,three"
    actual_value = ["one", "   two", "three"]
    assert test.is_equal(expected_value, actual_value), "Expected #{expected_value} to equal #{actual_value}"
  end

  def test_equals_with_expected_dates_in_correct_formats

    test = Sprat::Test.new(1,[],[])

    actual_value = "2014-01-24"

    expected_value = "2014-01-24"
    assert test.is_equal(expected_value, actual_value), "Expected #{expected_value} to equal #{actual_value} with exact string match"

    expected_value = "24/01/2014"
    assert test.is_equal(expected_value, actual_value), "Expected #{expected_value} to equal #{actual_value} with formatted date match"

    actual_value = "2014-01-23"
    assert !test.is_equal(expected_value, actual_value), "Expected #{expected_value} to NOT equal #{actual_value}"
  end

  def test_equals_with_expected_dates_in_wrong_formats

    test = Sprat::Test.new(1,[],[])

    actual_value = "2014-01-24"

    expected_value = "24 Jan 2014"
    assert !test.is_equal(expected_value, actual_value), "Expected #{expected_value} to equal #{actual_value}"

    expected_value = "2014-01-24T12:34"
    assert !test.is_equal(expected_value, actual_value), "Expected #{expected_value} to equal #{actual_value}"

  end

  def test_equals_with_dates_ignores_times

    test = Sprat::Test.new(1,[],[])

    expected_value = "24/01/2014"
    actual_value = "2014-01-24T13:45"
    assert test.is_equal(expected_value, actual_value), "Expected #{expected_value} to equal #{actual_value} ignoring times"
  end

  def test_comma_in_jsonpath_fails

    response = {}

    response["one, two"] = "some value"
    jsonpath = "$.['one, two']"

    test = Sprat::Test.new(1,[],[])

    result = test.get_response_value(response, jsonpath)

    # really we want to get "some value" returned, but comma is reserved for ranges in jsonpath
    assert_equal nil, result
  end

  def test_get_response_type
    test = Sprat::Test.new(1,[],[])

    response = ['one', 'two']
    result = test.get_response_type(response)
    assert_equal 'Array', result

    response = [1, 2, 3.5]
    result = test.get_response_type(response)
    assert_equal 'Array', result

    response = {'one' => 'a string', 'two' => 'another string'}
    result = test.get_response_type(response)
    assert_equal 'Hash', result

    response = {'one' => ['string 1', 'string 2']}
    result = test.get_response_type(response)
    assert_equal 'Hash', result

  end

  def test_get_response_value_simple_array
    test = Sprat::Test.new(1,[],[])

    # simple array
    response = [ 'one', 'two' ]

    jsonpath = '$.[0]'
    result = test.get_response_value(response, jsonpath)
    assert_equal 'one', result

    jsonpath = '$.[1]'
    result = test.get_response_value(response, jsonpath)
    assert_equal 'two', result

  end

  def test_get_response_value_simple_hash
    test = Sprat::Test.new(1,[],[])

    # simple hash
    response = { 'first' => 'one', 'second' => 'two' }

    jsonpath = '$.first'
    result = test.get_response_value(response, jsonpath)
    assert_equal 'one', result

    jsonpath = '$.second'
    result = test.get_response_value(response, jsonpath)
    assert_equal 'two', result

  end

  def test_get_response_value_with_root
    test = Sprat::Test.new(1,[],[])

    item1 = {'name' => 'one'}
    item2 = {'name' => 'two'}

    response = { 'root' => [item1, item2]}

    jsonpath = '$.root[0].name'
    result = test.get_response_value(response, jsonpath)
    assert_equal 'one', result

    jsonpath = '$.root[1].name'
    result = test.get_response_value(response, jsonpath)
    assert_equal 'two', result
  end

  def test_get_response_value_without_root
    test = Sprat::Test.new(1,[],[])

    item1 = {'name' => 'one'}
    item2 = {'name' => 'two'}

    response = [item1, item2]

    jsonpath = '$.[0].name'
    result = test.get_response_value(response, jsonpath)
    assert_equal 'one', result

  end

  def test_get_response_value_from_simple_hash
    test = Sprat::Test.new(1,[],[])

    response = {'name first' => 'one', 'name second' => 'two'}

    jsonpath = '$.["name second"]'
    result = test.get_response_value(response, jsonpath)
    assert_equal 'two', result

  end

  def test_make_jsonpath()
    test = Sprat::Test.new(1,[],[])
    original = 'name second'
    expected = '$.["name second"]'
    assert_equal expected, test.make_jsonpath(original)
  end

  # originally a bug in JSONPath
  def test_get_empty_response_values_when_path_not_found
    test = Sprat::Test.new(1,[],[])

    item1 = {'name' => 'one'}
    item2 = {'name' => 'two'}

    response = [item1, item2]

    jsonpath = '$.[99].name'
    result = test.get_response_value(response, jsonpath)
    assert_equal nil, result
  end

  def test_check_expectations_jsonpath

    outputs = [
      { 'path' => '$.root[0].name', 'value' => 'one', 'label' => 'Name1'},
      { 'path' => '$.root[1].name', 'value' => 'two', 'label' => 'Name2'}
    ]

    test = Sprat::Test.new(1,[],outputs)

    item1 = {'name' => 'one'}
    item2 = {'name' => 'two'}

    # root element has name
    response = { 'root' => [item1, item2]}

    msgs = []
    test.check_expectations_jsonpath(response, msgs)

    assert_equal [], msgs

  end

  def test_check_expectations_array_identifies_extras

    outputs = [
      { 'path' => 'one', 'value' => '', 'label' => 'one'},
      { 'path' => 'two', 'value' => 'Y', 'label' => 'two'},
      { 'path' => 'three', 'value' => '', 'label' => 'three'}
    ]

    test = Sprat::Test.new(1,[],outputs)

    # simple array
    response = [ 'two', 'four', 'five' ]

    msgs = []
    test.check_expectations_array(response, msgs)

    assert_equal ["four,five should not have been found"], msgs

  end

  def test_check_expectations_array_is_case_sensitive

    outputs = [
      { 'path' => 'One', 'value' => 'Y', 'label' => 'one'}
    ]

    test = Sprat::Test.new(1,[],outputs)

    # simple array
    response = [ 'ONE' ]

    msgs = []
    test.check_expectations_array(response, msgs)

    assert_equal ["One not found", "ONE should not have been found"], msgs

  end

  def test_check_expectations_array_identifies_empty_array

    outputs = [
      { 'path' => 'one', 'value' => 'Y', 'label' => 'one'}
    ]

    test = Sprat::Test.new(1,[],outputs)

    # simple array
    response = []

    msgs = []
    test.check_expectations_array(response, msgs)

    assert_equal ["No results returned"], msgs

  end


  def test_exec_handles_empty_response

    RSpec::Mocks.with_temporary_scope do
      test = Sprat::Test.new(1,{},[])

      api = MiniTest::Mock.new
      api.expect(:make_call, '', [{}])
      api.expect(:make_uri, '', [{}])

      results = test.exec(api)

      assert_equal 'FAIL', results.result
      assert_equal 'Response from api was empty', results.reason
    end

  end

end