class EsIndex::UpdateBrandMeasuresJob < EsIndex::BaseJob
  def perform(brand_id)
    Elastic::IndexUpdater.update_brand_measures(brand_id)
  end
end
