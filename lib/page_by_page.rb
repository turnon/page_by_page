require 'page_by_page/version'
require 'page_by_page/url'
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
    @url = Url.new tmpl
  end

  def selector sl
    @selector = sl
  end

  def fetch
    items, all_items = [nil], []
    catch :no_more do
      until items.empty?
        doc = parse @url.next
        items = doc.css @selector
        all_items << items
      end
    end
    all_items.flatten
  end

  private

  def parse url
    Nokogiri::HTML open url
  rescue OpenURI::HTTPError => e
    if e.message == '404 Not Found'
      throw :no_more
    else
      raise e
    end
  end

end
