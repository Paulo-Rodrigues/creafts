require "rails_helper"

describe ProductsController, type: :controller do
  context "POST #create" do
    it "creates a new product with valid parameters" do
      category = create(:category)

      valid_token = JsonWebToken.encode({ user_id: "test-user-123" })
      request.headers["AUTHORIZATION"] = "Bearer #{valid_token}"

      params = { product: { name: "New Product", description: "Product Description", category: category.name } }

      post :create, params: params

      expect(response).to have_http_status(:created)
      expect(json_response).to include(name: "New Product", description: "Product Description")
    end

    it "returns errors with invalid parameters" do
      category = create(:category)

      valid_token = JsonWebToken.encode({ user_id: "test-user-123" })
      request.headers["AUTHORIZATION"] = "Bearer #{valid_token}"

      params = { product: { name: nil, description: "Product Description", category: category.name } }

      post :create, params: params

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns unauthorized without a valid token" do
      post :create, params: {}

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
