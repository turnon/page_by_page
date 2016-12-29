require 'test_helper'

class PageByPageTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PageByPage::VERSION
  end

  def test_can_set_url_pattern
    pbp = PageByPage.new do
      url 'http://foo.com/bar?p=<%= n %>'
    end
    url = pbp.instance_variable_get :@url
    refute_nil url
  end

  def test_can_set_selector
    pbp = PageByPage.new do
      selector '.items'
    end
    selector = pbp.instance_variable_get :@selector
    refute_nil selector
  end

  def test_404
    pbp = PageByPage.new do
      url 'http://ifeve.com/page/<%= n%>'
      selector '.post .title'
    end
    nodes = pbp.fetch
    assert_equal '聊聊并发（一）深入分析Volatile的实现原理', nodes[-1].text
  end

end
