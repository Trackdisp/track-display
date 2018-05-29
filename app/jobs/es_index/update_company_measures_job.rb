class EsIndex::UpdateCompanyMeasuresJob < EsIndex::BaseJob
  def perform(company_id)
    Elastic::IndexUpdater.update_company_measures(company_id)
  end
end
