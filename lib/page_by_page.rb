require 'page_by_page/version'
require 'page_by_page/enum'
require 'nokogiri'
require 'open-uri'

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

  def fetch
    enum = Enum.new options
    items, all_items = [nil], []
    catch :no_more do
      until items.empty?
        n = enum.next
        break if n > limit
        url = @tmpl.result binding
        doc = parse url
        items = doc.css @selector
        all_items << items
      end
    end
    all_items.flatten
  end

  private

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
    opt[:from] = @from || 1
    opt[:step] = @step || 1
    opt
  end

  def limit
    @to || Float::INFINITY
  end

end
