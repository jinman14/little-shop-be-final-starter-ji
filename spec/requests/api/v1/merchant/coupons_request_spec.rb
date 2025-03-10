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

    @invoice1 = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "packaged", coupon_id: @coupon1.id)
    @invoice2 = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped", coupon_id: @coupon1.id)
    @invoice3 = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped", coupon_id: @coupon3.id)
    @invoice4 = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped", coupon_id: @coupon3.id)
    @invoice5 = Invoice.create!(customer: @customer1, merchant: @merchant2, status: "shipped", coupon_id: @coupon4.id)
  end

  it "should return all coupons associated with a given merchant" do
    get "/api/v1/merchants/#{@merchant1.id}/coupons"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(json[:data].count).to eq(3)
    expect(json[:data][0][:id]).to eq(@coupon1.id.to_s)
    expect(json[:data][0][:type]).to eq("coupon")
    expect(json[:data][0][:attributes][:name]).to eq("Coo-pin Time")
    expect(json[:data][0][:attributes][:code]).to eq("c0de")
    expect(json[:data][0][:attributes][:status]).to eq("active")
  end

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