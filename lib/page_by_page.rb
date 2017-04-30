require 'page_by_page/version'
require 'page_by_page/enum'
require 'page_by_page/mutex_enum'
require 'nokogiri'
require 'open-uri'
require 'erb'

class PageByPage

  class << self
    def fetch &block
      pbp = self.new &block
      pbp.fetch
    end
  end

  def initialize &block
    instance_eval &block
  end

  def url tmpl
    @tmpl = ERB.new tmpl
  end

  def selector sl
    @selector = sl
  end

  def from n
    @from = n
  end

  def step n
    @step = n
  end

  def to n
    @to = n
  end

  def threads n
    @threads = n
  end

  def fetch
    nodes_2d =
      unless defined? @threads
        @enum = Enum.new options
        _fetch
      else
        @enum = MutexEnum.new options
        parallel_fetch
      end
    nodes_2d.reject(&:nil?).flatten
  end

  private

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

  def parse url
    page = open(url)
    Nokogiri::HTML page.read
  rescue OpenURI::HTTPError => e
    if e.message == '404 Not Found'
      throw :no_more
    else
      raise e
    end
  end

  def options
    opt = {}
    opt[:from] = @from ||= 1
    opt[:step] = @step ||= 1
    opt
  end

  def limit
    @to ||= Float::INFINITY
  end

end
