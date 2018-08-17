module Elastic
  module WeightMeasureIndex
    extend ActiveSupport::Concern

    included do
      include Elastic::Indexable
      include Elasticsearch::Model

      index_name([Rails.application.engine_name, Rails.env, model_name.param_key].join('-'))

      settings do
        mappings do
          indexes :device_name, type: 'text'
          indexes :device_serial, type: 'text'
          indexes :device_active, type: 'boolean'
          indexes :campaign_name, type: 'text'
          indexes :company_name, type: 'text'
          indexes :location_name, type: 'text'
          indexes :brand_name, type: 'text'
          indexes :measured_at, type: 'date'
          indexes :item_weight, type: 'integer'
          indexes :shelf_weight, type: 'integer'
          indexes :current_weight, type: 'integer'
          indexes :previous_weight, type: 'integer'
          indexes :items_count, type: 'integer'
        end
      end

      def as_indexed_json(_options = {})
        as_json(methods: [:device_name, :device_serial, :device_active, :campaign_name,
                          :company_name, :location_name, :brand_name, :measured_at, :item_weight,
                          :shelf_weight, :current_weight, :previous_weight, :items_count])
      end
    end
  end
end
