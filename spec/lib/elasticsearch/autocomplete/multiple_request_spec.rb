require 'spec_helper'

module Elasticsearch
  module Autocomplete
    describe MultipleRequest do
      let(:type) { Object.new }
      let(:types) { [type] }
      let(:model) { MultipleRequest.new('index', 'search', types) }

      describe "#initialize" do
        it "sets the index" do
          expect(model.index).to eq('index')
        end

        it "has the search query string" do
          expect(model.query).to eq('search')
        end
      end

      describe "#body" do
        before(:each) do
          expect(type).to receive(:to_hash) { {here: 'today'} }
        end

        it "returns all types to hash" do
          expect(model.body.count).to eq(2)
        end

        it "returns index hash first" do
          expect(model.body.first).to eq({index: 'index'})
        end

        it "returns the type to hash" do
          expect(model.body.last).to eq({:here => 'today'})
        end
      end

      describe "#index_hash" do
        it "is private" do
          expect {
            model.index_hash
          }.to raise_error(NoMethodError)
        end

        it "returns the index in hash form" do
          expect(model.send(:index_hash)).to eq({index: 'index'})
        end
      end
    end
  end
end
