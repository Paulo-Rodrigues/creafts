require "rails_helper"

describe "Api::V1::User", type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.external_id) }
  let(:auth_headers) { { "Authorization" => "Bearer #{token}" } }

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

  context "GET /api/v1/me" do
    it "returns current user profile when authenticated" do
      get "/api/v1/me", headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response).to include(
        id: user.external_id,
        email: user.email
      )
      expect(json_response).not_to have_key(:password_digest)
    end

    it "returns unauthorized when token is missing" do
      get "/api/v1/me"

      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to have_key(:errors)
    end

    it "returns unauthorized when token is invalid" do
      invalid_headers = { "Authorization" => "Bearer invalid_token" }
      
      get "/api/v1/me", headers: invalid_headers

      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to have_key(:errors)
    end

    it "returns unauthorized when user doesn't exist" do
      non_existent_token = JsonWebToken.encode(user_id: "non-existent-id")
      invalid_headers = { "Authorization" => "Bearer #{non_existent_token}" }
      
      get "/api/v1/me", headers: invalid_headers

      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to have_key(:errors)
    end
  end

  context "PUT /api/v1/me" do
    it "successfully updates user profile" do
      update_params = { user: { email: "newemail@example.com" } }
      
      put "/api/v1/me", params: update_params, headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response[:email]).to eq("newemail@example.com")
      expect(json_response[:id]).to eq(user.external_id)
      
      user.reload
      expect(user.email).to eq("newemail@example.com")
    end

    it "returns validation errors for invalid data" do
      update_params = { user: { email: "invalid-email" } }
      
      put "/api/v1/me", params: update_params, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors]).to include(match(/email.*not a valid email/i))
    end

    it "returns error when trying to use existing email" do
      existing_user = create(:user, email: "existing@example.com")
      update_params = { user: { email: existing_user.email } }
      
      put "/api/v1/me", params: update_params, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors]).to include(match(/email.*already been taken/i))
    end

    it "returns unauthorized when token is missing" do
      update_params = { user: { email: "new@example.com" } }
      
      put "/api/v1/me", params: update_params

      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to have_key(:errors)
    end

    it "returns unauthorized when token is invalid" do
      update_params = { user: { email: "new@example.com" } }
      invalid_headers = { "Authorization" => "Bearer invalid_token" }
      
      put "/api/v1/me", params: update_params, headers: invalid_headers

      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to have_key(:errors)
    end

    it "allows updating only email (partial update)" do
      original_email = user.email
      update_params = { user: { email: "updated@example.com" } }
      
      put "/api/v1/me", params: update_params, headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response[:email]).to eq("updated@example.com")
      
      user.reload
      expect(user.email).to eq("updated@example.com")
    end
  end
end
