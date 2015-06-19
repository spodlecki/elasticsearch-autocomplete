require 'bundler/setup'
Bundler.setup

if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'elasticsearch/autocomplete'