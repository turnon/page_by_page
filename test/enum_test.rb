require 'test_helper'

class EnumTest < Minitest::Test

  def test_default_next
    enum = PageByPage::Enum.new
    assert_equal 1, enum.next
    assert_equal 2, enum.next
  end

  def test_from
    enum = PageByPage::Enum.new from: 0
    assert_equal 0, enum.next
    assert_equal 1, enum.next
  end

  def test_step
    enum = PageByPage::Enum.new step: 3
    assert_equal 1, enum.next
    assert_equal 4, enum.next
  end
end
