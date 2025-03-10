require "rails_helper"

describe "Coupon endpoints", :type => :request do
  describe "Get index coupons" do
    it "should return a list of all coupons" do
      create_list(:coupon, 5)
      get "/api/v1/coupons"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data]).to be_a Array
      expect(json[:data].count).to eq(5)
      expect(json[:data].first).to include(:id, :type, :attributes)
      expect(json[:data].first[:attributes]).to include(:name)
    end
  end

  describe "get show coupons" do
    it "should show a single coupon by id" do
      coupon = create(:coupon)

      get "/api/v1/coupons/#{coupon.id}"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data]).to include(:id, :type, :attributes)
      expect(json[:data][:id]).to eq(coupon.id.to_s)
      expect(json[:data][:type]).to eq("coupon")
      expect(json[:data][:attributes]).to include(:name)
      expect(json[:data][:attributes][:name]).to eq(coupon.name)
    end
  end
end