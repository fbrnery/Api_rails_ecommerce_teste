require "rails_helper"

RSpec.describe "Admin::V1::Categories", type: :request do
  let(:user) { create(:user) }

  context "GET /Categories" do
    let(:url) { "/admin/v1/categories" }
    let!(:categories) { create_list(:category, 5) }

    it "returns all Categories" do
      get url, headers: auth_header(user)
      expect(body_json["categories"]).to contain_exactly *categories.as_json(only: %i(id name))
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end
end

context "PATCH /categories/:id" do
  let(:category) { create(:category) }
  let(:url) { "/admin/v1/categories/#{category.id}" }
end

context "with valid params" do
  let(:new_name) { "My new Category" }
  let(:category_params) { { category: { name: new_name } }.to_json }
end

context "with invalid params" do
  let(:category_invalid_params) do
    { category: attributes_for(:category, name: nil) }.to_json

    it "does not update Category" do
      old_name = category.name
      patch url, headers: auth_header(user), params: category_invalid_params
      category.reload
      expect(category.name).to eq old_name
    end

    it "returns error message" do
      patch url, headers: auth_header(user), params: category_invalid_params
      expect(body_json["errors"]["fields"]).to have_key("name")
    end

    it "returns unprocessable_entity status" do
      patch url, headers: auth_header(user), params: category_invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "updates Category" do
      patch url, headers: auth_header(user), params: category_params
      category.reload
      expect(category.name).to eq new_name
    end
    it "returns updated Category" do
      patch url, headers: auth_header(user), params: category_params
      category.reload
      expected_category = category.as_json(only: %i(id name))
      expect(body_json["category"]).to eq expected_category
    end

    it "returns success status" do
      patch url, headers: auth_header(user), params: category_params
      expect(response).to have_http_status(:ok)
    end
  end
end
