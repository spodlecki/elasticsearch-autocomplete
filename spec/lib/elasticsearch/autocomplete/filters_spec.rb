require 'spec_helper'

module Elasticsearch
  module Autocomplete
    describe Filters do
      describe ".analysis" do
        before(:each) do
          @hash = Filters.analysis
          @analyzer = @hash[:analysis]
        end
        it "returns as a hash" do
          expect(@hash).to be_a(Hash)
        end

        it "returns :analysis" do
          expect(@hash[:analysis]).to be_a(Hash)
        end

        it "returns :filter" do
          expect(@analyzer[:filter]).to be_a(Hash)
        end

        it "returns :analyzer" do
          expect(@analyzer[:analyzer]).to be_a(Hash)
        end
      end

      [:config, :build_config].each do |m|
        describe ".#{m}" do
          it "returns a multi_field config" do
            expect(Filters.public_send(m, :name)[:type]).to eq(:multi_field)
          end

          it "returns fields config" do
            expect(Filters.public_send(m, :name)[:fields]).to be_a(Hash)
          end

          describe "fields" do
            before(:each) do
              @fields = Filters.public_send(m, :name)[:fields]
            end

            it "has default" do
              expect(@fields[:name]).to eq( {type: 'string'})
            end

            it "has .exact" do
              expect(@fields[:'name.exact']).to eq({ type: 'string', index_analyzer: 'simple' })
            end

            it "has .autocomplete" do
              expect(@fields[:'name.autocomplete']).to eq({ type: 'string', index_analyzer: 'autocomplete'})
            end

            it "has .beginning" do
              expect(@fields[:'name.beginning']).to eq({ type: 'string', index_analyzer: 'beginning'})
            end

            it "has .fuzzy" do
              expect(@fields[:'name.fuzzy']).to eq({ type: 'string', index_analyzer: 'fuzzy'})
            end
          end
        end
      end
    end
  end
end