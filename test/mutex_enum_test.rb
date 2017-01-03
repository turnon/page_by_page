require 'test_helper'

class MutexEnumTest < Minitest::Test

  def test_multithreads
    enum = PageByPage::MutexEnum.new

    threads = 4.times.map do
      Thread.new do
        while (n = enum.next) <= 10
          sleep rand 0..1
          (Thread.current[:store] ||= []) << n
        end
      end
    end

    numbers = threads.map do |t|
      t.join
      t[:store]
    end.flatten

    uniq_num = Set.new numbers

    assert_equal Set.new(1..10), uniq_num
  end
end
