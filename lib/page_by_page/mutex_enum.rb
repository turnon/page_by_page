require 'page_by_page/enum'

class PageByPage
  class MutexEnum < Enum

    def initialize from: 1, step: 1
      super
      @q = SizedQueue.new 10
      Thread.new do
        loop do
          @q << @enum.next
          sleep 0.1
        end
      end
    end

    def next
      @q.deq
    end

  end
end
