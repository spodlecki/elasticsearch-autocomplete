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
    class MultipleRequest < Request
      def body
        @body ||= begin
          result = []
          types.each do |t|
            result << index_hash
            result << t.to_hash
          end

          result
        end
      end

    private

      def index_hash
        {:index => index}
      end
    end
  end
end