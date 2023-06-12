# SortParam

[![Gem Version](https://badge.fury.io/rb/sort_param.svg)](https://badge.fury.io/rb/sort_param) [![CI](https://github.com/jsonb-uy/sort_param/actions/workflows/ruby.yml/badge.svg?branch=main)](https://github.com/jsonb-uy/sort_param/actions/workflows/ruby.yml) [![codecov](https://codecov.io/gh/jsonb-uy/sort_param/branch/main/graph/badge.svg?token=09RE3PZW4G)](https://codecov.io/gh/jsonb-uy/sort_param) [![Maintainability](https://api.codeclimate.com/v1/badges/d1655f67377c21e9618a/maintainability)](https://codeclimate.com/github/jsonb-uy/sort_param/maintainability)

Sort records using a query parameter based on JSON API's sort parameter format.

In a nutshell, this gem converts comma-separated sort fields from this:
<pre>
?sort=<b>+users.first_name,-users.last_name:nulls_last,users.email</b>
</pre>


to this:
```SQL
users.first_name asc, users.last_name desc nulls last, users.email asc
```

or to this:
```ruby
{"users.first_name"=>{:direction=>:asc}, "users.last_name"=>{:direction=>:desc, :nulls=>:last}, "users.email"=>{:direction=>:asc}}
```

## Features

* Sort field whitelisting.
* Supports `ORDER BY` expression generation for MySQL and PG.
* Parsing of comma-separated sort fields into hash for any further processing.
* Specifying `NULL` sort order.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sort_param'
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install sort_param
```

## Usage

### Basic


#### 1. Whitelist/define the sort fields

```ruby
sort_param = SortParam.define do
               field :first_name, nulls: :first
               field :last_name
             end
```


OR we can do:

```ruby
sort_param = SortParam::Definition.new
                                  .field(:first_name, nulls: :first)
                                  .field(:last_name)
```

`field` method accepts the column name as the first argument. Any default column configuration such as `:nulls`(for `NULLS FIRST` or `NULLS LAST` sort order) follows the name.

#### 2. Parse sort fields from a parameter

The `load!` method translates a given sort string/fields parameter to an SQL ORDER BY expression or to a Hash: 

##### I. PostgreSQL example

```ruby
sort_param.load!("+first_name,-last_name", mode: :pg)

=> "first_name asc nulls first, last_name desc"
```

##### II. MySQL example

```ruby
sort_param.load!("+first_name,-last_name", mode: :mysql)

=> "first_name is not null, first_name asc, last_name desc"
```

##### III. Hash example

```ruby
sort_param.load!("+first_name,-last_name")

=> {"first_name"=>{:nulls=>:first, :direction=>:asc}, "last_name"=>{:direction=>:desc}}
```

Any other additional column option set in `SortParam::Definition` or `SortParam.define` will be included in the column's hash value.
For example:

```ruby
sort_param = SortParam.define do
               field :first_name, foo: :bar, nulls: :first
             end

sort_param.load!("+first_name")
=> {"first_name"=>{:foo=>:bar, :nulls=>:first, :direction=>:asc}}

sort_param.load!("-first_name:nulls_last")
=> {"first_name"=>{:foo=>:bar, :nulls=>:last, :direction=>:desc}}
```

#### IV. Example with explicit nulls sort order

###### Example in PG mode:

```ruby
sort_param.load!("+first_name:nulls_last,-last_name:nulls_first", mode: :pg)

=> "first_name asc nulls last, last_name desc nulls first"
```
<br/>

### Rails example

```ruby
def index 
  render json: User.all.order(sort_fields)
end

private

def sort_fields
  SortParam.define do
    field :first_name
    field :last_name, nulls: :first
  end.load!(sort_param, mode: :pg)
end

# Fetch the sort fields from :sort query parameter.
# If none is given, default sort by `first_name ASC` and `last_name ASC NULLS FIRST`.
def sort_param
  params[:sort].presence || "+first_name,+last_name"
end
```

We can DRY this up a bit by creating a concern:

#### controllers/concerns/has_sort_param.rb

```ruby
module HasSortParam
  extend ActiveSupport::Concern

  def sort_param(default: nil, &block)
    raise ArgumentError.new('Missing block') unless block_given?

    definition = SortParam.define(&block)
    definition.load!(params[:sort].presence || default, mode: :pg)
  end
end
```

### controller

```ruby
def index 
  render json: User.all.order(sort_fields)
end

private

def sort_fields
  sort_param default: '+first_name,-last_name' do
    field :first_name
    field :last_name, nulls: :first
  end
end
```

### Error

| Class | Description |
| ----------- | ----------- |
| `SortParam::UnsupportedSortField` | Raised when a sort field from the parameter isn't included in the whitelisted sort fields. |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jsonb-uy/sort_param.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
