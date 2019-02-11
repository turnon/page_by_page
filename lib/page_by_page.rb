require 'page_by_page/version'
require 'page_by_page/fetch'
require 'page_by_page/jump'
require 'nokogiri'
require 'open-uri'

class PageByPage

  include Fetch
  include Jump

  class << self
    def fetch(*args, &block)
      new(*args, &block).fetch
    end

    def jump(*args, &block)
      new(*args, &block).jump
    end
  end

  def initialize(opt = {}, &block)
    @from, @step, @to = 1, 1, Float::INFINITY
    @progress = {}
    opt.each{ |name, value| send name, value }
    instance_eval &block if block
  end

  def to n
    @to = n
  end

  def selector sl
    @selector = sl
  end

  def header hash
    @header = hash
  end

  def interval second
    @interval = second
  end

  private

  def parse url
    page = open(url, http_header)
    Nokogiri::HTML page.read
  rescue OpenURI::HTTPError => e
    if e.message == '404 Not Found'
      throw :no_more
    else
      raise e
    end
  end

  def http_header
    @http_header ||= (
      h = {}
      Hash(@header).each_pair{ |k, v| h[k.to_s] = v }
      h
    )
  end

  def limit
    @to ||= Float::INFINITY
  end

  def update_progress thread, page_num
    @progress[thread] = page_num
    printf "\r%s => %s", Time.now.strftime('%F %T'), @progress.values.sort
  end

end
