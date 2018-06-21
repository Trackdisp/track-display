require 'rails_helper'

describe WeightMeasureObserver do
  let(:object) { create(:weight_measure) }

  def trigger(type, event)
    described_class.trigger(type, event, object)
  end

  def expect_update_es_index
    expect(Elastic::IndexUpdater).to(
      receive(:queue_update_weight_measure).with(object.id)
    )
  end

  describe '#after_save' do
    it "updates ES index" do
      expect_update_es_index

      trigger(:after, :save)
    end
  end

  describe '#after_destroy' do
    it "updates ES index" do
      expect_update_es_index

      trigger(:after, :destroy)
    end
  end
end
