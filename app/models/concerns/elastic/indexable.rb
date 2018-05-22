module Elastic
  module Indexable
    def create_index!(options = {})
      destroy_index! if options[:force]
      client.indices.create(
        index: index_name,
        body: {
          settings: settings.to_hash,
          mappings: mappings.to_hash
        }
      )
    end

    def refresh_index!
      client.indices.refresh
    end

    def destroy_index!
      client.indices.delete(index: index_name)
    rescue
      nil
    end

    def es_search(q)
      __elasticsearch__.search(q)
    end

    def client
      __elasticsearch__.client
    end
  end
end
