module Elastic
  module MeasureIndex
    extend ActiveSupport::Concern

    included do
      include Elastic::Indexable
      include Elasticsearch::Model

      index_name([Rails.application.engine_name, Rails.env, model_name.param_key].join('-'))

      settings do
        mappings do
          indexes :device_name, type: 'text'
          indexes :device_serial, type: 'text'
          indexes :company_name, type: 'text'
        end
      end

      def as_indexed_json(_options = {})
        as_json(methods: [:device_name, :device_serial, :company_name])
      end
    end
  end
end
