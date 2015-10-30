require 'spec_helper'

module Elasticsearch
  module Autocomplete
    describe Response do
      let(:request) { Object.new }
      let(:type) { Object.new }
      let(:types) { [type] }
      let(:model) { Response.new(types, request) }
      let(:http_response) {
        {
          'responses' => [
            {
              'hits' => {
                'hits' => [
                  {
                    '_source' => {field: 'source'},
                    '_type' => 'alpha',
                    '_score' => 10
                  },
                  {
                    '_source' => {field: 'alpha'},
                    '_type' => 'beta',
                    '_score' => 10
                  }
                ]
              }
            },
            {
              'hits' => {
                'hits' => [
                  {
                    '_source' => {field: 'beta'},
                    '_type' => 'beta',
                    '_score' => 10
                  },
                  {
                    '_source' => {field: 'beta'},
                    '_type' => 'beta',
                    '_score' => 10
                  }
                ]
              }
            }
          ]
        }
      }
      before(:each) do
        allow(Elasticsearch::Model).to receive_message_chain(:client, :msearch) { http_response }
        allow(request).to receive(:body) { {} }
      end

      describe "#initialize" do
        it "sets the types" do
          expect(model.types).to eq(types)
        end
        it "sets the request" do
          expect(model.request).to eq(request)
        end
      end

      describe "#body" do
        it "is delegated to #request" do
          expect(request).to receive(:body) { {} }
          model.body
        end
      end

      describe "#to_a" do
        it "maps results with a single type" do
          expect(type).to receive(:type).at_least(:once) { 'beta' }
          expect(type).to receive(:mapped).exactly(3).times { {src: 'MAPPED'} }
          expect(model).to receive(:results) { http_response['responses'] }
          model.to_a
        end

        it "maps results with a multiple types" do
          expect(type).to receive(:type).at_least(:once) { ['alpha', 'beta'] }
          expect(type).to receive(:mapped).exactly(4).times { {src: 'MAPPED'} }
          expect(model).to receive(:results) { http_response['responses'] }
          model.to_a
        end
      end

      describe "#each" do
        before(:each) do
          expect(type).to receive(:type).at_least(:once) { 'alpha' }
          expect(type).to receive(:mapped).at_least(:once) { {src: 'MAPPED'} }
          expect(model).to receive(:results) { http_response['responses'] }
        end

        it "returns both responses" do
          expect(model.count).to eq(2)
        end

        it "returns each blocked group as an array" do
          model.each do |group|
            expect(group).to be_a(Array)
          end
        end
      end

      describe "#parse_response" do
        before(:each) do
          expect(type).to receive(:type).at_least(:once) { 'alpha' }
          expect(type).to receive(:mapped).at_least(:once) { {src: 'MAPPED'} }
        end

        it "returns mapped based on _type" do
          result = model.send(:parse_response, http_response['responses'].first)
          expect(result).to eq(
            [{:src=>"MAPPED", :_score=>10, :_type=>"alpha", :_highlight=>nil}, {:field=>"alpha", :_score=>10, :_type=>"beta", :_highlight=>nil}]
          )
        end
      end
    end
  end
end