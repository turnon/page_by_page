require 'test_helper'

class PageByPageTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PageByPage::VERSION
  end

  def test_can_set_url_pattern
    pbp = PageByPage.new do
      url 'http://foo.com/bar?p=<%= n %>'
    end
    url = pbp.instance_variable_get :@tmpl
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
    skip
    pbp = PageByPage.new do
      url 'http://ifeve.com/page/<%= n%>'
      selector '.post h3.title'
    end
    nodes = pbp.fetch
    assert_equal '聊聊并发（一）深入分析Volatile的实现原理', nodes[-1].text
  end

  def test_can_define_from_and_step
    pbp = PageByPage.new do
      url 'https://book.douban.com/subject/4774858/reviews?start=<%= n%>'
      selector '.review-item'
      from 0
      step 20
    end
    nodes = pbp.fetch
    assert 30 > nodes.count
  end

  def test_can_define_to
    pbp = PageByPage.new do
      url 'http://ifeve.com/page/<%= n%>'
      selector '.post_wrap'
      to 3
    end
    nodes = pbp.fetch
    assert_equal 45, nodes.count
  end

end
