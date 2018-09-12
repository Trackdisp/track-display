require 'rails_helper'

describe CalculateUnitsExtracted do
  def perform(*_args)
    described_class.for(*_args)
  end
end
