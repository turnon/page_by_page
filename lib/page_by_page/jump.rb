require 'page_by_page/common'

module PageByPage
  class Jump

    include Common

    def start url
      @start = url
    end

    def iterate selector
      @iterate = selector
    end

    def process
      url, items, page_count = @start, [], 0

      while true do
        doc = parse url
        doc.css(@selector).each{ |item| items << item }

        next_url = doc.at_css(@iterate)
        break unless next_url

        path = next_url.attr('href')
        url = concat_host path

        page_count += 1
        update_progress Thread.current, page_count if @progress
        break if page_count >= limit

        sleep @interval if @interval
      end

      items
    end

    private

    def concat_host path
      @prefix = (
        regex = path.start_with?('/') ? /([^:|\/])\/.*/ : /(.*[^:|\/])\/.*/
        @start.gsub(regex, '\1')
      )
      File.join @prefix, path
    end
  end
end
