require "rails_helper"

describe "Api::V1::Auth", type: :request do
  context "POST /login" do
    it "successfully logs in with valid credentials" do
      user = create(:user)

      post "/api/v1/login", params: { email: user.email, password: user.password }

      expect(response).to have_http_status(:ok)
      expect(json_response).to have_key(:token)
    end

    it "fails to log in with invalid credentials" do
      post "/api/v1/login", params: { email: "invalid", password: "invalid" }

      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to have_key(:error)
    end
  end
end
