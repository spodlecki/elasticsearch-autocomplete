###
# Returns the search body as a hash for autocomplete module
#
# Building the hash in a specific format is vital to developing
# a multi-query search from elasticsearch. Results are returned in the specific
# order you submit the query in.
#
# Each 'type' should have a corrisponding class.
# Example:
# If the type would be a 'tag'-
# => Elasticsearch::Autocomplete::TagType
###

module Elasticsearch
  module Autocomplete
    class Request
      attr_accessor :query, :types, :index

      def initialize(index, query, types)
        self.query = query
        self.types = types
        self.index = index
      end

      def body
        {}
      end
    end
  end
end