require 'page_by_page/enum'
require 'thread'

module PageByPage
  class MutexEnum < Enum

    def initialize enum
      @q = SizedQueue.new 10
      @enum = enum
      Thread.new do
        loop do
          @q << @enum.next
        end
      end
    end

    def next
      @q.deq
    end

  end
end
