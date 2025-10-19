require 'rails_helper'

RSpec.describe Price, type: :model do
  context "validations" do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  end

  context "associations" do
    it { is_expected.to belong_to(:product) }
  end
end
