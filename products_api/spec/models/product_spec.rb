require 'rails_helper'

RSpec.describe Product, type: :model do
  context "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to define_enum_for(:status).with_values(unavailable: 0, available: 1) }

    it 'defaults status to available' do
      product = create(:product)

      expect(product.status).to eq("available")
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many_attached(:images) }
    it { is_expected.to have_many(:price).dependent(:destroy) }
  end
end
