module Elasticsearch
  module Autocomplete
    class SingleResponse < Response

      def each(&block)
        members = parse_response(results)
        members.each do |member|
          block.call(member)
        end
      end

    protected

      def search
        @search ||= Elasticsearch::Model.client.search(body)
      end
    end
  end
end