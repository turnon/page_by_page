require 'forwardable'
require 'erb'

class PageByPage
  class Url
    extend Forwardable

    def_delegator :@enum, :next

    def initialize tmpl, from: 1, step: 1
      @tmpl = ERB.new tmpl
      @enum = Enumerator.new do |yielder|
        n = from
        loop do
          rendered = @tmpl.result binding
          yielder.yield rendered
          n = n + step
        end
      end
    end

  end
end
