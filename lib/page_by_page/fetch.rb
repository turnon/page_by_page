require 'page_by_page/enum'
require 'page_by_page/mutex_enum'
require 'page_by_page/common'
require 'erb'

module PageByPage
  class Fetch

    include Common

    def initialize(opt = {}, &block)
      @from, @step, @to = 1, 1, Float::INFINITY
      super
    end

    def url tmpl
      @tmpl = ERB.new tmpl
    end

    def from n
      @from = n
    end

    def step n
      @step = n
    end

    def threads n
      @threads = n
    end

    def process
      nodes_2d =
        unless defined? @threads
          @enum = Enum.new enum_options
          _fetch
        else
          @enum = MutexEnum.new enum_options
          parallel_fetch
        end
      puts if @progress
      nodes_2d.reject(&:nil?).flatten
    end

    protected

    def _fetch
      items, pages = [nil], []
      catch :no_more do
        until items.empty?
          n = @enum.next
          break if n > limit

          url = @tmpl.result binding
          doc = parse url
          items = doc.css @selector
          pages[n] = items

          update_progress Thread.current, n if @progress
          sleep @interval if @interval
        end
      end
      pages
    end

    def parallel_fetch
      ts = @threads.times.map do |n|
        Thread.new do
          Thread.current[:sub] = _fetch
        end
      end
      ts.each_with_object([]) do |t, pages|
        t.join
        t[:sub].each_with_index do |items, i|
          pages[i] = items if items
        end
      end
    end

    def enum_options
      {from: @from, step: @step}
    end

  end
end
