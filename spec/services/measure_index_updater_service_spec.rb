require 'rails_helper'

describe MeasureIndexUpdaterService do
  let(:srv) { described_class.new }

  describe "#update_measure" do
    let(:measure_id) { double }
    let(:perform) { srv.update_measure(measure_id) }

    before { expect(Measure).to receive(:update_document).with(measure_id).and_return(true) }

    it { expect(perform).to eq(true) }
  end
end
