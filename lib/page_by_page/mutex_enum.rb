require 'page_by_page/enum'
require 'thread'

module PageByPage
  class MutexEnum < Enum

    def initialize from: 1, step: 1, limit: nil, enumerator: nil
      super
      @q = SizedQueue.new 10
      Thread.new do
        loop do
          n = @enum.next rescue nil
          @q << n
        end
      end
    end

    def next
      @q.deq
    end

  end
end
