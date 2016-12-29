require 'test_helper'

class UrlTest < Minitest::Test

  def setup
    @url = PageByPage::Url.new 'http://foo.com/bar?p=<%= n %>'
  end

  def test_next
    assert_equal 'http://foo.com/bar?p=1', @url.next
    assert_equal 'http://foo.com/bar?p=2', @url.next
  end
end
