require "rails_helper"

describe "Api::V1::User", type: :request do
  context "POST /api/v1/users" do
    it "successfully creates a user" do
      user_params = attributes_for(:user)

      post "/api/v1/users", params: { user: user_params }

      expect(response).to have_http_status(:created)
      expect(json_response).to have_key(:token)
    end

    it "returns an error when something is wrong" do
      user_params = attributes_for(:user, email: nil)

      post "/api/v1/users", params: { user: user_params }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors]).to include("Email can't be blank")
    end
  end
end
