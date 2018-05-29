module Elastic
  module Indexable
    extend ActiveSupport::Concern

    included do
      def update_document
        __elasticsearch__.update_document
        true
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        false
      end

      def delete_document
        __elasticsearch__.delete_document
        true
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        false
      end

      def index_document
        __elasticsearch__.index_document
        true
      end
    end

    class_methods do
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

      def update_document(object_id)
        object = find_by(id: object_id)

        if object
          object.index_document unless object.update_document
          return
        end

        new(id: object_id).delete_document
      end

      def es_search(q)
        __elasticsearch__.search(q)
      end

      def client
        __elasticsearch__.client
      end
    end
  end
end
