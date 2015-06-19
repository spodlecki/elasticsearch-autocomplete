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
    describe Search do
      let(:index) { 'index' }
      let(:query) { 'search' }
      let(:types) { ['tag'] }
      let(:model) { Search.new(index, query, types) }

      it "returns types collected in classes" do
        expect(model.types.first).to be_a(Elasticsearch::Autocomplete::TagType)
      end

      describe "#initialize" do
        it "sets query" do
          expect(model.query).to eq(query)
        end

        it "sets types" do
          expect(model.types.first).to be_a(TagType)
        end

        it "sets index" do
          expect(model.index).to eq(index)
        end

        describe "single search" do
          describe "valid" do
            before(:each) do
              @s = Search.new(index, query, types, false, :name)
            end

            it "turns off multisearch" do
              expect(@s.multisearch).to eq(false)
            end

            it "sets the field" do
              expect(@s.field).to eq(:name)
            end
          end
          describe "invalid" do
            it "raises error when no field is set" do
              expect {
                Search.new(index, query, types, false)
              }.to raise_error(RuntimeError)
            end
          end
        end
      end

      describe "#results" do
        describe "multiple responses" do
          it "starts a new MultipleResponse" do
            request = Object.new
            expect(model).to receive(:request) { request }
            expect(MultipleResponse).to receive(:new).with(model.types, request)
            model.results
          end
        end

        describe "single response" do
          it "starts a new SingleResponse" do
            request = Object.new
            expect(model).to receive(:request) { request }
            expect(model).to receive(:multisearch) { false }
            expect(SingleResponse).to receive(:new).with(model.types, request)
            model.results
          end
        end
      end

      describe "#request" do
        describe "multiple responses" do
          it "starts a new Response" do
            request = Object.new
            expect(MultipleRequest).to receive(:new).with(index, query, model.types)
            model.request
          end
        end

        describe "single response" do
          it "starts a new Response" do
            request = Object.new
            expect(model).to receive(:multisearch) { false }
            expect(model).to receive(:field) { :blah }
            expect(SingleRequest).to receive(:new).with(index, query, model.types, :blah)
            model.request
          end
        end
      end

      describe "#types_mapped" do
        it "is private" do
          expect {
            model.types_mapped(['tag'])
          }.to raise_error(NoMethodError)
        end

        it "explodes when class does not exist" do
          expect {
            model.send(:types_mapped, ['category'])
          }.to raise_error(NameError)
        end
        it "turns a strng to array" do
          expect(model.send(:types_mapped, 'tag').count).to eq(1)
        end

        it "maps to class" do
          expect(model.send(:types_mapped, 'tag').first).to be_a(Elasticsearch::Autocomplete::TagType)
        end
      end
    end
  end
end