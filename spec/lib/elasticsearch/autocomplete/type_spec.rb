require 'spec_helper'

module Elasticsearch
  module Autocomplete
    class TagType < Type

      def field
        :name
      end

      def to_hash
        {:here => 'today'}
      end
    end
  end
end

module Elasticsearch
  module Autocomplete
    describe Type do
      let(:abstract) { Type.new('search') }
      let(:model) { TagType.new('search') }

      it "#query is set on init" do
        expect(abstract.query).to eq('search')
      end

      describe "#field" do
        it "raises error when not replaced" do
          expect {
            abstract.field
          }.to raise_error(RuntimeError)
        end

        it "returns parent class" do
          expect(model.field).to eq(:name)
        end
      end

      describe "#to_hash" do
        it "raises error when not replaced" do
          expect {
            abstract.to_hash
          }.to raise_error(RuntimeError)
        end

        it "returns parent details" do
          expect(model.to_hash).to eq({here: 'today'})
        end
      end

      describe "#multi_match" do
        it "is a shortcut for bool auto query" do
          expect(model.send(:multi_match)).to eq(
            {:multi_match=>{:query=>"search", :type=>"most_fields", :fields=>[:"name.exact^10", :"name.beginning^7", :"name.autocomplete^5", :"name.fuzzy^1"], :tie_breaker=>0.3}}
          )
        end

        it "can override ranks" do
          expect(model.send(:multi_match, {exact: 15})).to eq(
            {:multi_match=>{:query=>"search", :type=>"most_fields", :fields=>[:"name.exact^15", :"name.beginning^7", :"name.autocomplete^5", :"name.fuzzy^1"], :tie_breaker=>0.3}}
          )
        end

        it "can override query string" do
          expect(model.send(:multi_match, {exact: 15}, 'qs')).to eq(
            {:multi_match=>{:query=>"qs", :type=>"most_fields", :fields=>[:"name.exact^15", :"name.beginning^7", :"name.autocomplete^5", :"name.fuzzy^1"], :tie_breaker=>0.3}}
          )
        end

        it "can override field name" do
          expect(model.send(:multi_match, {exact: 15}, 'qs', :foo)).to eq(
            {:multi_match=>{:query=>"qs", :type=>"most_fields", :fields=>[:"foo.exact^15", :"foo.beginning^7", :"foo.autocomplete^5", :"foo.fuzzy^1"], :tie_breaker=>0.3}}
          )
        end
      end
    end
  end
end