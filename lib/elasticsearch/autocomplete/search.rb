module Elasticsearch
  module Autocomplete
    class Search
      module ClassMethods
        def find(index, query, types=[])
          search = self.new(index, query, types)
        end
      end
      extend ClassMethods

      attr_accessor :query, :types, :index, :multisearch, :field

      def initialize(index, query, types, multisearch=true, field=nil)
        raise "Specify a field when running a single search." if multisearch == false && field.nil?

        self.query = query
        self.types = types_mapped(types)
        self.index = index

        self.multisearch = multisearch
        self.field = field
      end

      def results
        @results ||= begin
          if multisearch
            MultipleResponse.new(types, request)
          else
            SingleResponse.new(types, request)
          end
        end
      end

      def request
        @request ||= begin
          if multisearch
            MultipleRequest.new(index, query, types)
          else
            SingleRequest.new(index, query, types, field)
          end
        end
      end

    private

      def types_mapped(types)
        types = Array(types)

        types.map do |type|

          "Elasticsearch::Autocomplete::#{type.capitalize}Type".constantize
                                                  .new(query)
        end
      end
    end
  end
end