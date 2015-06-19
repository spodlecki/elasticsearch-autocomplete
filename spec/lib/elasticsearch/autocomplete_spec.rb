require 'spec_helper'

module Elasticsearch
  describe Autocomplete do
    it 'has a version number' do
      expect(Autocomplete::VERSION).not_to be nil
    end
  end
end