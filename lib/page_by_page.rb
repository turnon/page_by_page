require 'page_by_page/version'
require 'page_by_page/fetch'
require 'page_by_page/jump'

module PageByPage

  class << self
    def fetch(*args, &block)
      Fetch.new(*args, &block).process
    end

    def lazy_fetch(*args, &block)
      Fetch.new(*args, &block).iterator
    end

    def jump(*args, &block)
      Jump.new(*args, &block).process
    end
  end

end
