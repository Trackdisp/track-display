require 'rails_helper'

RSpec.describe WeightMeasuresSync, type: :model do
  describe '#Validations' do
    it { should validate_presence_of :state }
    it { should validate_presence_of :from_date }
    it { should validate_presence_of :to_date }
  end

  describe '#Relationships' do
    it { should have_many(:weight_measures) }
  end

  describe 'aasm' do
    context '#execute' do
      it 'changes state from created to executing' do
        expect { subject.execute }.to change(subject, :state).from('created').to('executing')
      end

      it 'sets value to start_date' do
        subject.execute
        expect(subject.start_time).not_to be(nil)
      end

      it 'should raise InvalidTransition error if is failed' do
        subject.execute
        subject.fail
        expect { subject.complete }.to raise_exception(AASM::InvalidTransition)
      end

      it 'should raise InvalidTransition error if is completed' do
        subject.execute
        subject.complete
        expect { subject.complete }.to raise_exception(AASM::InvalidTransition)
      end
    end

    context '#fail' do
      it 'changes state from executing to failed' do
        subject.execute
        expect { subject.fail }.to change(subject, :state).from('executing').to('failed')
      end

      it 'sets value to end_time' do
        subject.execute
        subject.fail
        expect(subject.end_time).not_to be(nil)
      end

      it 'should raise InvalidTransition error if not executing' do
        expect { subject.fail }.to raise_exception(AASM::InvalidTransition)
      end
    end

    context '#complete' do
      it 'changes state from executing to completed' do
        subject.execute
        expect { subject.complete }.to change(subject, :state).from('executing').to('completed')
      end

      it 'sets value to end_time' do
        subject.execute
        subject.complete
        expect(subject.end_time).not_to be(nil)
      end

      it 'should raise InvalidTransition error if not executing' do
        expect { subject.complete }.to raise_exception(AASM::InvalidTransition)
      end
    end
  end
end
