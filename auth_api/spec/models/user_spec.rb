require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }

    it "create a user with external_id" do
      user = create(:user)

      expect(user.external_id).to be_present
    end

    it "format of email" do
      user = build(:user, email: "invalid_email")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is not a valid email")
    end

    it "returns an error when password confirmation does not match" do
      user = build(:user, password: "password123", password_confirmation: "different123")

      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it "returns an error when email is already taken" do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)

      expect(user2).not_to be_valid
      expect(user2.errors[:email]).to include("has already been taken")
    end

    it "returns an error when password is too short" do
      user = build(:user, password: "short", password_confirmation: "short")

      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end
end
