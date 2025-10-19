require 'rails_helper'

RSpec.describe Category, type: :model do
  context "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to define_enum_for(:status).with_values(inactive: 0, active: 1) }

    it "defaults active to true" do
      category = create(:category)

      expect(category.status).to eq("active")
    end
  end

  context "associations" do
    it { is_expected.to have_many(:products) }
  end
end
