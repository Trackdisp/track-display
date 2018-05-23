require 'rails_helper'

describe CampaignObserver do
  let(:object) { create(:campaign) }
  let(:job) { double(perform_later: true) }

  def trigger(type, event)
    described_class.trigger(type, event, object)
  end

  def expect_update_es_index
    expect(EsIndex::UpdateCampaignMeasuresJob).to receive(:delayed).and_return(job)
    expect(job).to receive(:perform_later).with(object.id)
  end

  describe '#after_save' do
    it "updates ES index" do
      expect_update_es_index

      trigger(:after, :save)
    end
  end
end
