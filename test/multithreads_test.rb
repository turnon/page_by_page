require 'test_helper'

class MultithreadsTest < Minitest::Test

  def test_multithreads
    t1 = Time.now

    para_nodes = PageByPage.fetch do
      url 'http://ifeve.com/page/<%= n%>'
      selector '.post_wrap'
      to 10
      threads 4
    end

    t2 = Time.now

    nodes = PageByPage.fetch do
      url 'http://ifeve.com/page/<%= n%>'
      selector '.post_wrap'
      to 10
    end

    t3 = Time.now

    assert_equal nodes.count, para_nodes.count
    assert_faster t1, t2, t3
  end

  private

  def assert_faster t1, t2, t3
    first = t2 - t1
    second = t3 - t2
    assert first < (second / 2), "#{first} should be 2 times less than #{second}"
  end

end
