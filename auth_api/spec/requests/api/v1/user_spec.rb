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

  context "PUT /api/v1/change_password" do
    let(:current_password) { "password" }
    let(:new_password) { "newpassword456" }

    it "successfully changes password with valid current password" do
      password_params = {
        current_password: current_password,
        new_password: new_password,
        new_password_confirmation: new_password
      }
      
      put "/api/v1/change_password", params: password_params, headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response).to include(message: "Password changed successfully")
      
      # Verify user can login with new password
      user.reload
      expect(user.authenticate(new_password)).to be_truthy
      expect(user.authenticate(current_password)).to be_falsey
    end

    it "returns error when current password is incorrect" do
      password_params = {
        current_password: "wrongpassword",
        new_password: new_password,
        new_password_confirmation: new_password
      }
      
      put "/api/v1/change_password", params: password_params, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors]).to include("Current password is incorrect")
    end

    it "returns error when new password is too short" do
      password_params = {
        current_password: current_password,
        new_password: "123",
        new_password_confirmation: "123"
      }
      
      put "/api/v1/change_password", params: password_params, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors]).to include("Password is too short (minimum is 6 characters)")
    end

    it "returns error when new password confirmation doesn't match" do
      password_params = {
        current_password: current_password,
        new_password: new_password,
        new_password_confirmation: "differentpassword"
      }
      
      put "/api/v1/change_password", params: password_params, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors]).to include("Password confirmation doesn't match Password")
    end

    it "returns error when current password is missing" do
      password_params = {
        new_password: new_password,
        new_password_confirmation: new_password
      }
      
      put "/api/v1/change_password", params: password_params, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors]).to include("Current password can't be blank")
    end

    it "returns error when new password is missing" do
      password_params = {
        current_password: current_password,
        new_password_confirmation: new_password
      }
      
      put "/api/v1/change_password", params: password_params, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors]).to include("Password can't be blank")
    end

    it "returns unauthorized when token is missing" do
      password_params = {
        current_password: current_password,
        new_password: new_password,
        new_password_confirmation: new_password
      }
      
      put "/api/v1/change_password", params: password_params

      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to have_key(:errors)
    end

    it "returns unauthorized when token is invalid" do
      password_params = {
        current_password: current_password,
        new_password: new_password,
        new_password_confirmation: new_password
      }
      invalid_headers = { "Authorization" => "Bearer invalid_token" }
      
      put "/api/v1/change_password", params: password_params, headers: invalid_headers

      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to have_key(:errors)
    end

    it "doesn't change password when validation fails" do
      original_password_digest = user.password_digest
      password_params = {
        current_password: "wrongpassword",
        new_password: new_password,
        new_password_confirmation: new_password
      }
      
      put "/api/v1/change_password", params: password_params, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
      
      # Verify password wasn't changed
      user.reload
      expect(user.password_digest).to eq(original_password_digest)
      expect(user.authenticate(current_password)).to be_truthy
    end
  end
end
