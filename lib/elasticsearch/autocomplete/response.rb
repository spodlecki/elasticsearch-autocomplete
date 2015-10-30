require 'ostruct'
require 'elasticsearch/model'

module Elasticsearch
  module Autocomplete
    class Response
      include Enumerable

      delegate :body, to: :request

      attr_accessor :types, :request, :results

      def initialize(types, request)
        self.request = request
        self.types = types
        self.results = search
      end

      def each(&block)
        results.each do |result|
          member = parse_response(result)

          block.call(member)
        end
      end

    protected

      def search
        r = Elasticsearch::Model.client.msearch(:body => body)
        r['responses']
      end

      def parse_response(results)
        results['hits']['hits'].map do |search_result|
          src = search_result['_source']
          type = search_result['_type']
          score = search_result['_score']
          highlight = search_result['highlight']
          returned_type = types.select{|t| Array(t.type).include?(type) }.first

          if returned_type
            returned_type.mapped(
              OpenStruct.new(src)
            )
          else
            src
          end.merge(:_score => score, :_type => type, :_highlight => highlight)
        end
      end

    end
  end
end