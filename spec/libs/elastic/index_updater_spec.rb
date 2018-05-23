require 'rails_helper'

describe Elastic::IndexUpdater do
  describe "#update_measure" do
    let(:measure_id) { double }
    let(:perform) { described_class.update_measure(measure_id) }

    before { expect(Measure).to receive(:update_document).with(measure_id).and_return(true) }

    it { expect(perform).to eq(true) }
  end

  describe "#queue_update_measure" do
    let(:measure_id) { double }
    let(:job) { double(perform_later: true) }
    let(:perform) { described_class.queue_update_measure(measure_id) }

    before do
      expect(EsIndex::UpdateMeasureJob).to receive(:delayed).and_return(job)
      expect(job).to receive(:perform_later).with(measure_id)
    end

    it { expect(perform).to eq(true) }
  end
end
