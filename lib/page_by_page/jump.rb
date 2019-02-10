class PageByPage
  module Jump

    def start url
      @start = url
    end

    def iterate selector
      @iterate = selector
    end

    def jump
      url, items, page_count = @start, [], 0

      while true do
        doc = parse url
        doc.css(@selector).each{ |item| items << item }

        next_url = doc.at_css(@iterate)
        break unless next_url

        path = next_url.attr('href')
        url = concat_host path

        page_count += 1
        break if page_count >= limit
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
