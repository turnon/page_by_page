# PageByPage

Scrape page by page, according to url pattern, return an array of Nokogiri::XML::Element you want.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'page_by_page'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install page_by_page

## Usage

```ruby
nodes = PageByPage.fetch do
  url 'https://book.douban.com/subject/25846075/comments/hot?p=<%= n %>'
  selector '.comment-item'
end
```

