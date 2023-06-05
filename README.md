# SortParam

Sort records using a query parameter based on JSON API's sorting format.

## Features

* Supports `ORDER BY` expression generation for MySQL and PG.
* Parse the sort string/expression into hash for any further processing.

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
  users = User.all.order(order_by)
end

private

def order_by
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
