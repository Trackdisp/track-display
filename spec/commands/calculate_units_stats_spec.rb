require 'rails_helper'

describe CalculateUnitsStats do
  def perform(*_args)
    described_class.for(*_args)
  end
end
