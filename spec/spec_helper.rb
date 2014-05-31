# encoding: utf-8
require 'rubygems'

RSpec.configure do |config|
  config.color = true
  config.order = :random
end

require 'simplecov'
SimpleCov.start do
  add_filter do |file|
    not file.filename =~ /^#{SimpleCov.root}\/lib/
  end
end

require 'merge_enum'

require 'rspec_term'
RSpecTerm.configure do |config|
  config.success_url = 'https://raw.githubusercontent.com/brightgenerous/rspec_term/master/images/success.jpg'
  config.running_url = 'https://raw.githubusercontent.com/brightgenerous/rspec_term/master/images/running.jpg'
  config.failure_url = 'https://raw.githubusercontent.com/brightgenerous/rspec_term/master/images/failure.jpg'
  config.nothing_url = 'https://raw.githubusercontent.com/brightgenerous/rspec_term/master/images/nothing.jpg'
  config.tmp_dir = '/tmp/rspec_term'
  config.coverage do
    SimpleCov.result.covered_percent
  end
  config.coverage_url do |coverage|
    case coverage
      when 100
        'https://raw.githubusercontent.com/brightgenerous/rspec_term/master/images/coverage_100.jpg'
    end
  end
end

