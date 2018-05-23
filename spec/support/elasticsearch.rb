require 'elasticsearch/extensions/test/cluster'

ELASTIC_SEARCH_TEST_PORT = 9250

RSpec.configure do |config|
  # def stop_elastic
  #   Elasticsearch::Extensions::Test::Cluster.stop(
  #     port: ELASTIC_SEARCH_TEST_PORT,
  #     number_of_nodes: 1
  #   )
  # rescue Errno::ECONNREFUSED
  #   nil
  # end
  #
  # def start_elastic
  #   Elasticsearch::Extensions::Test::Cluster.start(
  #     port: ELASTIC_SEARCH_TEST_PORT,
  #     number_of_nodes: 1,
  #     timeout: 120
  #   )
  # end
  #
  # # Start an in-memory cluster for Elasticsearch as needed
  # config.before :all, elasticsearch: true do
  #   start_elastic
  # end
  #
  # # Stop elasticsearch cluster after test run
  # config.after :suite do
  #   stop_elastic
  # end

  # Create indexes for all elastic searchable models
  config.before :each, elasticsearch: true do
    ActiveRecord::Base.descendants.each do |model|
      if model.respond_to?(:__elasticsearch__)
        begin
          model.create_index!(force: true)
        rescue Elasticsearch::Transport::Transport::Errors::NotFound
          # This kills "Index does not exist" errors being written to console
          # by this: https://github.com/elastic/elasticsearch-rails/blob/738c63efacc167b6e8faae3b01a1a0135cfc8bbb/elasticsearch-model/lib/elasticsearch/model/indexing.rb#L268
        rescue => e
          STDERR.puts "Error creating the elasticsearch index for #{model.name}: #{e.inspect}"
        end
      end
    end
  end

  # Delete indexes for all elastic searchable models to ensure clean state between tests
  config.after :each, elasticsearch: true do
    ActiveRecord::Base.descendants.each do |model|
      if model.respond_to?(:__elasticsearch__)
        begin
          model.destroy_index!
        rescue Elasticsearch::Transport::Transport::Errors::NotFound
          # This kills "Index does not exist" errors being written to console
        rescue => e
          STDERR.puts "Error removing the elasticsearch index for #{model.name}: #{e.inspect}"
        end
      end
    end
  end
end
