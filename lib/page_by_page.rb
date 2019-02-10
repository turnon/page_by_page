require 'page_by_page/version'
require 'page_by_page/fetch'
require 'nokogiri'
require 'open-uri'

class PageByPage

  include Fetch

  class << self
    def fetch(opt ={}, &block)
      pbp = self.new(opt, &block)
      pbp.fetch
    end
  end

  def initialize(opt = {}, &block)
    @from, @step, @to = 1, 1, Float::INFINITY
    @progress = {}
    opt.each{ |name, value| send name, value }
    instance_eval &block if block
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
    {from: @from, step: @step}
  end

  def limit
    @to ||= Float::INFINITY
  end

  def update_progress thread, page_num
    @progress[thread] = page_num
    printf "\r%s => %s", Time.now.strftime('%F %T'), @progress.values.sort
  end

end
