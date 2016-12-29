require 'test_helper'
require 'open-uri'

class DslTest < Minitest::Test

  def setup
    @nodes = PageByPage.fetch do
      url 'https://book.douban.com/subject/4774858/comments/hot?p=<%= n %>'
      selector '.comment-item'
    end
  end

  def test_can_fetch_all_pages
    count = total_count 'https://book.douban.com/subject/4774858/comments/'
    assert_equal count, @nodes.count
  end

  def test_work_as_nokogiri
    assert @nodes.any? { |n| /rails开发一条龙/ =~ comment_content(n) }
    assert @nodes.any? { |n| /RoR入门/ =~ comment_content(n) }
  end

  private

  def total_count url
    page = open url
    m = /全部共 (\d+) 条/.match page.read
    m[1].to_i
  end

  def comment_content node
    node.at_css('.comment-content').text
  end

end
