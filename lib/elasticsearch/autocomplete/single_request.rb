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
    class SingleRequest < Request
      attr_accessor :field

      def initialize(index, query, types, field)
        super(index, query, types)
        self.field = field
      end

      def body
        @body ||= begin
          {
            :index => index,
            :type => types.map(&:type).uniq,
            :body => {
              :query => Type.single_search(query, field)
            }
          }
        end
      end
    end
  end
end