require 'rails_helper'

describe CalculateUnitsRotated do
  def perform(*_args)
    described_class.for(*_args)
  end
end
