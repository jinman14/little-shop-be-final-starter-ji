require "rails_helper"

describe Coupon, type: :model do
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

end