require 'forwardable'
require 'erb'

class PageByPage
  class Url
    extend Forwardable

    def_delegator :@enum, :next

    def initialize tmpl
      @tmpl = ERB.new tmpl
      @enum = Enumerator.new do |yielder|
        n = 1
        loop do
          rendered = @tmpl.result binding
          yielder.yield rendered
          n = n.succ
        end
      end
    end

  end
end
