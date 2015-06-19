require 'spec_helper'

module Elasticsearch
  module Autocomplete
    describe SingleRequest do
      let(:type) { Object.new }
      let(:types) { [type] }
      let(:model) { SingleRequest.new('index', 'search', types, :name) }

      describe "#initialize" do
        it "sets the index" do
          expect(model.index).to eq('index')
        end

        it "has the search query string" do
          expect(model.query).to eq('search')
        end

        it "has the field" do
          expect(model.field).to eq(:name)
        end
      end

      describe "#body" do
        before(:each) do
          expect(type).to receive(:type) { 'tag' }
        end

        it "returns index key" do
          expect(model.body[:index]).to eq('index')
        end

        it "returns type array" do
          expect(model.body[:type]).to eq(['tag'])
        end

        it "returns the body query" do
          expect(model.body[:body]).to eq(
            {:query=>{:multi_match=>{:query=>"search", :type=>"most_fields", :fields=>[:"name.exact^10", :"name.beginning^7", :"name.autocomplete^5", :"name.fuzzy^1"], :tie_breaker=>0.3}}}
          )
        end
      end
    end
  end
end
