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
      @enum = (defined?(@threads) ? MutexEnum : Enum).new(enum_options)
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

    def enumerator e
      @enumerator = e
    end

    def process
      nodes_2d = defined?(@threads) ? parallel_fetch : _fetch
      puts if @progress

      nodes_2d.sort.each_with_object([]) do |key_items, res|
        res.concat key_items[1] unless key_items[1].nil?
      end
    end

    def iterator
      Enumerator.new do |yielder|
        items_enum.each do |_, items|
          items.each do |i|
            yielder.yield(i)
          end
        end
      end
    end

    protected

    def _fetch
      pages = {}

      items_enum.each do |page_num, items|
        pages[page_num] = items
      end

      pages
    end

    def items_enum
      Enumerator.new do |yielder|
        items = [nil]
        catch :no_more do
          until items.empty?
            n = @enum.next
            break if n.nil?

            url = @tmpl.result binding
            doc = parse url
            items = doc.css @selector
            yielder.yield(n, items)

            update_progress Thread.current, n if @progress
            sleep @interval if @interval
          end
        end
      end
    end

    def parallel_fetch
      ts = @threads.times.map do |n|
        Thread.new do
          Thread.current[:sub] = _fetch
        end
      end
      ts.each_with_object({}) do |t, pages|
        t.join
        pages.merge! t[:sub]
      end
    end

    def enum_options
      {from: @from, step: @step, limit: limit, enumerator: @enumerator}
    end

  end
end
