elastic_search_host = ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200'
Elasticsearch::Model.client = Elasticsearch::Client.new(host: elastic_search_host)

if Rails.env.development?
  tracer = ActiveSupport::Logger.new(STDERR)
  tracer.level = Logger::INFO
  tracer.formatter = proc { |_s, _d, _p, m| "\e[2m#{m}\n\e[0m" }
  Elasticsearch::Model.client.transport.logger = tracer
end
