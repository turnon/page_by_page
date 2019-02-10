require 'test_helper'
require 'open-uri'

class DslTest < Minitest::Test

  def setup
    @nodes = PageByPage.fetch do
      url 'https://book.douban.com/subject/4774858/comments/new?p=<%= n %>'
      selector '.comment-item'
      no_progress
    end

    @nodes_2 = PageByPage.fetch(
      url: 'https://book.douban.com/subject/4774858/comments/new?p=<%= n %>',
      selector: '.comment-item',
      no_progress: true
    )

    @nodes_3 = PageByPage.jump(
      start: 'https://book.douban.com/subject/4774858/comments/new',
      selector: '.comment-item',
      iterate: '.comment-paginator li:nth-child(3) a'
    )
  end

  def test_can_fetch_all_pages
    count = total_count 'https://book.douban.com/subject/4774858/comments/'
    assert_equal count, @nodes.count
    assert_equal count, @nodes_2.count
    assert_equal count, @nodes_3.count
  end

  def test_work_as_nokogiri
    [@nodes, @nodes_2, @nodes_3].each do |nodes|
      assert_test_work_as_nokogiri nodes
    end
  end

  private

  def assert_test_work_as_nokogiri nodes
    assert nodes.any? { |n| /第四版太一般了/ =~ comment_content(n) }
    assert nodes.any? { |n| /RoR入门/ =~ comment_content(n) }
  end

  def total_count url
    page = open url
    m = /全部共 (\d+) 条/.match page.read
    m[1].to_i
  end

  def comment_content node
    node.at_css('.comment-content').text
  end

end
