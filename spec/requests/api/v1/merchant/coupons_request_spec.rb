require "rails_helper"

RSpec.describe "Merchant coupon endpoints" do
  before :each do
    @merchant2 = Merchant.create!(name: "Merchant")
    @merchant1 = Merchant.create!(name: "Merchant Again")

    @customer1 = Customer.create!(first_name: "Papa", last_name: "Gino")
    @customer2 = Customer.create!(first_name: "Jimmy", last_name: "John")

    @coupon1 = Coupon.create!(name: "Coo-pin Time", code: "c0de", discount: 10.00, merchant: @merchant1, status: 'active')
    @coupon2 = Coupon.create!(name: "Coop Coop", code: "cod3", discount: 25.00, merchant: @merchant1, status: 'inactive')
    @coupon3 = Coupon.create!(name: "Cooooop", code: "whoaThree", discount: 50.00, merchant: @merchant1, status: 'active')
    @coupon4 = Coupon.create!(name: "Four?", code: "areyakiddin", discount: 75.00, merchant: @merchant2, status: 'active')
    @coupon5 = Coupon.create!(name: "anotha one", code: "thirty", discount: 30.00, merchant: @merchant1, status: 'active')
    @coupon6 = Coupon.create!(name: "Last one", code: "g01ng2break", discount: 20.0, merchant: @merchant1, status: 'active')

    @invoice1 = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "packaged", coupon_id: @coupon1.id)
    @invoice2 = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped", coupon_id: @coupon1.id)
    @invoice3 = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped", coupon_id: @coupon3.id)
    @invoice4 = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped", coupon_id: @coupon3.id)
    @invoice5 = Invoice.create!(customer: @customer1, merchant: @merchant2, status: "shipped", coupon_id: @coupon4.id)
  end
  
  describe "GET Index" do
    it "should return all coupons associated with a given merchant" do
      get "/api/v1/merchants/#{@merchant1.id}/coupons"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(json[:data].count).to eq(5)
      expect(json[:data][0][:id]).to eq(@coupon1.id.to_s)
      expect(json[:data][0][:type]).to eq("coupon")
      expect(json[:data][0][:attributes][:name]).to eq("Coo-pin Time")
      expect(json[:data][0][:attributes][:code]).to eq("c0de")
      expect(json[:data][0][:attributes][:status]).to eq("active")
    end
  end
  describe "GET Show" do
    it "should return a single coupon related to a merchant" do
      get "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}"

      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      expect(json[:data]).to be_a(Hash)
      expect(json[:data][:id]).to eq(@coupon1.id.to_s)
      expect(json[:data][:attributes][:name]).to eq(@coupon1.name.to_s)
      expect(json[:data][:attributes][:discount]).to eq("10.0")
      expect(json[:data][:attributes][:usage_count]).to eq(2)
    end
  end

  describe "Create Coupon" do
    it "can create a coupon associated with a merchant" do
      name = "New Coo"
      code = "S0 N3w"
      discount = "100.0"
      status = "inactive"
      newcoupon = {
        coupon: {
          name: name,
          code: code,
          discount: discount,
          status: status
        }
      }
      post "/api/v1/merchants/#{@merchant1.id}/coupons", params: newcoupon, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:attributes][:name]).to eq(name)
      expect(json[:data][:attributes][:code]).to eq(code)
      expect(json[:data][:attributes][:discount]).to eq(discount)
      expect(json[:data][:attributes][:status]).to eq(status)
    end

    it "won't create a new active coupon if a merchant already has 5 active" do
      coupon7 = Coupon.create!(name: "For real", code: "rightNAO", discount: 1.0, merchant: @merchant1, status: 'active')

      name = "New Coo"
      code = "S0 N3w"
      discount = "100.0"
      status = "active"
      newcoupon = {
        coupon: {
          name: name,
          code: code,
          discount: discount,
          status: status
        }
      }

      post "/api/v1/merchants/#{@merchant1.id}/coupons", params: newcoupon, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(422)
      expect(json[:errors]).to eq(["This merchant already has 5 active coupons. Deactivate an old coupon to add a new one."])
    end
  end

  describe "Update Coupons" do
    it "can update attributes" do
      updates = {
        name: "NEW NAME",
        status: "inactive"
      }

      patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}", params: updates, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:id]).to eq(@coupon1.id.to_s)
      expect(json[:data][:attributes][:name]).to eq("NEW NAME")
      expect(json[:data][:attributes][:status]).to eq("inactive")
    end

    it "won't update the status to active if there are already 5 active coupons" do
      coupon7 = Coupon.create!(name: "For real", code: "rightNAO", discount: 1.0, merchant: @merchant1, status: 'active')

      updates = {
        name: "NEW NAME",
        status: "active"
      }

      patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon2.id}", params: updates, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(422)
      expect(json[:errors]).to eq(["Status Merchant already has 5 active coupons"])
    end
  end
end