require "rails_helper"

describe User, type: :model do
  context "validations" do
    it { is_expected.to validate_presence_of(:external_id) }
  end
end
