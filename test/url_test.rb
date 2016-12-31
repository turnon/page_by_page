require 'test_helper'

class UrlTest < Minitest::Test

  def test_default_next
    url = PageByPage::Url.new 'http://foo.com/bar?p=<%= n %>'
    assert_equal 'http://foo.com/bar?p=1', url.next
    assert_equal 'http://foo.com/bar?p=2', url.next
  end

  def test_from
    url = PageByPage::Url.new 'http://foo.com/bar?p=<%= n %>', from: 0
    assert_equal 'http://foo.com/bar?p=0', url.next
    assert_equal 'http://foo.com/bar?p=1', url.next
  end

  def test_step
    url = PageByPage::Url.new 'http://foo.com/bar?p=<%= n %>', step: 3
    assert_equal 'http://foo.com/bar?p=1', url.next
    assert_equal 'http://foo.com/bar?p=4', url.next
  end
end
