# TODO
# Add beginning of entire string rank

module Elasticsearch
  module Autocomplete
    module Filters
      module ClassMethods
        def analysis
          {
            analysis: {
              analyzer: {
                simple: {
                  type: "custom",
                  tokenizer: "standard",
                  filter: [ "standard", "lowercase", "stop" ]
                },
                autocomplete: {
                  type: "custom",
                  tokenizer: "standard",
                  filter: [ 'asciifolding', "standard", "lowercase", "stop", "kstem", "ngram_front" ]
                },
                fuzzy: {
                  type: "custom",
                  tokenizer: "standard",
                  filter: [ 'asciifolding', "standard", "lowercase", "stop", "kstem", "ngram_short" ]
                },
                beginning: {
                  type: "custom",
                  tokenizer: "keyword",
                  filter: [ "lowercase", 'asciifolding', 'ngram_beginning' ]
                }
              },
              filter: {
                ngram_beginning: {
                  type: "edgeNGram",
                  min_gram: 2,
                  max_gram: 30
                },
                ngram_front: {
                  type: "edgeNGram",
                  min_gram: 2,
                  max_gram: 15
                },
                ngram_short: {
                  type: "ngram",
                  min_gram: 2,
                  max_gram: 15
                }
              }
            }
          }
        end

        def build_config(field, add_options_to_fields={})
          {
            :type => :multi_field,
            :fields => {
              field.to_sym => { type: 'string' }.merge(add_options_to_fields),
              :"#{field}.exact" => { type: 'string', index_analyzer: 'simple' }.merge(add_options_to_fields),
              :"#{field}.beginning" => { type: 'string', index_analyzer: 'beginning'}.merge(add_options_to_fields),
              :"#{field}.autocomplete" => { type: 'string', index_analyzer: 'autocomplete'}.merge(add_options_to_fields),
              :"#{field}.fuzzy" => { type: 'string', index_analyzer: 'fuzzy'}.merge(add_options_to_fields)
            }
          }
        end

        alias_method :config, :build_config
      end
      extend ClassMethods
    end
  end
end