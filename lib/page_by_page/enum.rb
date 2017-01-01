require 'forwardable'
require 'erb'

class PageByPage
  class Enum
    extend Forwardable

    def_delegator :@enum, :next

    def initialize from: 1, step: 1
      @enum = Enumerator.new do |yielder|
        n = from
        loop do
          yielder.yield n
          n = n + step
        end
      end
    end

  end
end
