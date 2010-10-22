require 'helper'

class TestTappie < Test::Unit::TestCase
  
  should "run a block if it exists" do
    tapped = false
    "Guilherme Silveira".tap { tapped = true }
    assert tapped
  end

  should "return itself" do
    a_friendly_guy = "Guilherme Silveira"
    assert_equal a_friendly_guy.tap { }, a_friendly_guy
  end

  should "allow access to the object itself as self" do
    char_len = -1
    a_friendly_guy = "Guilherme Silveira"
    a_friendly_guy.tap { char_len = size }
    assert_equal 18, char_len
  end
  
  should "old style run a block if it exists" do
    tapped = false
    "Guilherme Silveira".tap { |who| tapped = true }
    assert tapped
  end

  should "old style return itself" do
    a_friendly_guy = "Guilherme Silveira"
    assert_equal a_friendly_guy.tap { |who| }, a_friendly_guy
  end

  should "old style allow access to the object itself as self" do
    char_len = -1
    a_friendly_guy = "Guilherme Silveira"
    a_friendly_guy.tap { |who| char_len = who.size }
    assert_equal 18, char_len
  end
  
  should "taps if it has no block" do
    a_friendly_guy = "Guilherme Silveira"
    assert_equal a_friendly_guy, a_friendly_guy.tap
  end
  
end
