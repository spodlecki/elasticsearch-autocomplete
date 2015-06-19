require 'action_controller'

module Elasticsearch
  module Autocomplete
    class Type

      module ClassMethods
        def single_search(query, field)
          t = self.new(query)
          t.send(:multi_match, {}, query, field)
        end
      end

      extend ClassMethods

      attr_accessor :query

      def initialize(query)
        self.query = query
      end

      # => String
      def type
        raise "Replace #type with the ElasticSearch _type"
      end

      # => Hash
      def to_hash
        raise "Replace #to_hash with ElasticSearch Query Hash"
      end

      # Return the hash to which the result is mapped from
      # @param source {OpenStruct} Source value from ElasticSearch result
      # => Hash
      def mapped(source)
        raise "Replace #mapped with a mapped response hash"
      end

      # The field to search on
      # You'll only need this if you intend on using the search
      # helpers below
      #
      def field
        raise "Replace #field with the ElasticSearch field name"
      end

    protected

      def image_path(img)
        return if img.blank?
        ActionController::Base.helpers.image_path(img)
      end

      # https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-multi-match-query.html
      # Quickly use the multiple fields matcher search format
      # => { query: multi_match({exact: 30}) }
      #
      def multi_match(rank_overrides={}, query_override=nil, field_override=nil, tie_breaker=0.3)
        ranks = {exact: 10, beginning: 7, autocomplete: 5, fuzzy: 1}.merge(rank_overrides)
        field_override ||= field
        query_override ||= query

        {
          :multi_match => {
            :query  => query_override,
            :type   => 'most_fields',
            :fields => ranks.map{|k,v| :"#{field_override}.#{k}^#{v}" },
            :tie_breaker =>  tie_breaker
          }
        }
      end
    end
  end
end