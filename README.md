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

### number pattern

If you know page number pattern, use `fetch`:

```ruby
nodes = PageByPage.fetch do
  url 'https://book.douban.com/subject/25846075/comments/hot?p=<%= n %>'
  selector '.comment-item'
  # from 2
  # step 2
  # to 100
  # interval 3
  # threads 4
  # no_progress
  # header Cookie: 'douban-fav-remind=1'
end
```

### other pattern

If the pattern is not simple numbers, use `enumerator` in `fetch`:

```ruby
nodes = PageByiPage.fetch do
  url 'http://mysql.taobao.org/monthly/<%= n %>'
  selector 'h3'
  enumerator ['2020/09/', '2020/08/'].to_enum
end
```

### unknown pattern

If you don't know the pattern, but you see link to next page, use `jump`:

```ruby
nodes = PageByPage.jump do
  start 'https://book.douban.com/subject/25846075/comments/hot'
  iterate '.comment-paginator li:nth-child(3) a'
  selector '.comment-item'
  # to 100
  # interval 3
  # no_progress
  # header Cookie: 'douban-fav-remind=1'
end
```

### parameters instead of block

You may just pass parameters instead of block:

```ruby
nodes = PageByPage.fetch(
  url: 'https://book.douban.com/subject/25846075/comments/hot?p=<%= n %>',
  selector: '.comment-item',
  # from: 2,
  # step: 2,
  # to: 100,
  # interval: 3
  # threads: 4,
  # no_progress: true
  # header: {Cookie: 'douban-fav-remind=1'}
)
```

### lazy

Also note that, instead of Array, `lazy_fetch` returns an Enumerator, which is native lazy-loading:

```ruby
nodes = PageByPage.lazy_fetch(
  #...
)
```
