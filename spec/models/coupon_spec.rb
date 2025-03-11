require "rails_helper"

describe Coupon, type: :model do

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

  describe 'associations' do
    it { should belong_to :merchant }
    it { should have_many :invoices }
  end
  
  it 'creates a valid coupon' do
    coupon = create(:coupon)
    expect(coupon).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:discount) }

    it { should validate_uniqueness_of(:code) }
  end

  it 'ensures unique code' do
    merchant = create(:merchant)

    create(:coupon, code: 'DISCOO', merchant: merchant)
    duplicate_coupon = build(:coupon, code: 'DISCOO', merchant: merchant)

    expect(duplicate_coupon).to be_invalid
    expect(duplicate_coupon.errors[:code]).to include('has already been taken')
  end

  it 'can count its usage based on invoices it appears in' do
    expect(@coupon1.usage_count).to eq(2)
  end

  describe 'activity checker' do
    it 'can sort by active' do
      status = 'active'

      expect(Coupon.coupon_activity_by_merchant(@merchant1, status)).to eq([@coupon1, @coupon3, @coupon5, @coupon6])
    end

    it 'can sort by inactive' do
      status = 'inactive'

      expect(Coupon.coupon_activity_by_merchant(@merchant1, status)).to eq([@coupon2])
    end
  end

  it 'functions with no activity and will just return a list of coupons' do
      expect(Coupon.coupon_activity_by_merchant(@merchant1)).to eq([@coupon1, @coupon2, @coupon3, @coupon5, @coupon6])
  end
end