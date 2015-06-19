# ElasticSearch Autocomplete
[![Code Climate](https://codeclimate.com/github/spodlecki/elasticsearch-autocomplete/badges/gpa.svg)](https://codeclimate.com/github/spodlecki/elasticsearch-autocomplete)
[![Test Coverage](https://codeclimate.com/github/spodlecki/elasticsearch-autocomplete/badges/coverage.svg)](https://codeclimate.com/github/spodlecki/elasticsearch-autocomplete/coverage)
[![Build Status](https://travis-ci.org/spodlecki/elasticsearch-autocomplete.svg)](https://travis-ci.org/spodlecki/elasticsearch-autocomplete)

Quick and simple way to perform autocomplete with ElasticSearch Servers.

## Installation

Add this line to your application's Gemfile:

```
gem 'elasticsearch-autocomplete'
```

And then execute:

    $ bundle install

## Dependencies

- [Elasticsearch::Model](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model)
- [Rails > 3.2.8](http://rubyonrails.org/)
- [Elasticsearch Server > 1.0.1](http://www.elastic.co)

## Usage

### Field Explaination

![Quick Brown Fox](http://i57.tinypic.com/vdivie.png)
Access each field as if they were a nested attribute (`field.fuzzy`, `field.exact`, ...).

### Searching

**map file**
(**ROOT**/lib/elasticsearch/autocomplete/**TYPE**_type.rb)

```
module Elasticsearch
  module Autocomplete
    class ColorType < Type
      # Value of ElasticSearch's _type
      # => String
      def type
        'color'
      end

      # Search Hash
      # This is the entire search query for ElasticSearch
      #
      def to_hash
        {
          query: { match_all: {}},
          filter: {
            and: [
              { term: {_type: 'color'} }
            ]
          }
        }
      end

      # Return the hash to which the result is mapped from
      # @method mapped
      # @param source {OpenStruct} Source value from ElasticSearch result
      # @return Hash
      #
      def mapped(source)
        {
          id: source.id,
          name: source.name,
          image: image_path(source.icon),
          type: type
        }
      end

      # Optional to set
      # If you intend on using any of the helpers, this will need to be set
      #
      def field
        :name
      end
    end
  end
end
```

**controller**
```
# Search Multiple Types, each with their own query
search = Elasticsearch::Autocomplete::Search.find(index_string, params[:term], ['actress'])
search.results # => []

# Multiple Types, with a single result set
# @param index {String} ElasticSearch Index Name
# @param term {String} Query String being searched
# @param types {Array} Array of types being searched for in ElasticSearch
# @param multisearch {Boolean} Are we splitting each type into its own query?
# @param field {String|Symbol} If doing a single query, pass the name of the field to be searched
search = Elasticsearch::Autocomplete::Search.find(index_string, params[:term], ['actress'], false, :name)
search.results # => []
```

**model indexing**
```
# Assuming you are using Elasticsearch::Model as your indexing tool

mapping do
  # ...
  # Normal
  indexes :field_name, Elasticsearch::Autocomplete::Filters.config(:field_name)

  # Merge options to fields
  indexes :field_name, Elasticsearch::Autocomplete::Filters.config(:field_name, {options_here: :now})

  # .config returns as a hash, so you are able to merge there as well
  # ...
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Type Helper Methods

```
def image_path(image_string)
  # => Generates an asset url for an image
end
```

```
# https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-multi-match-query.html
# Quickly use the multiple fields matcher search format
# Usage: { query: multi_match({exact: 30}) }
#
def multi_match(rank_overrides={})
  ranks = {exact: 10, beginning: 7, autocomplete: 5, fuzzy: 1}.merge(rank_overrides)

  {..}
  # => returns built hash for the multi_match query
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

- Create generator for new types
- Get codeclimate online