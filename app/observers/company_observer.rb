class CompanyObserver < PowerTypes::Observer
  after_save :update_es_index

  def update_es_index
    EsIndex::UpdateCompanyMeasuresJob.delayed.perform_later(object.id)
  end
end
