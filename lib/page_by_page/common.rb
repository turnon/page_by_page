require 'nokogiri'
require 'open-uri'

module PageByPage
  module Common
    def initialize(opt = {}, &block)
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

    def no_progress *arg
      @progress = nil
    end

    protected

    def parse url
      url = URI::encode url
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
end
