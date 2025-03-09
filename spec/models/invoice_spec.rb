require "rails_helper"

RSpec.describe Invoice do
  let(:coupon) { create(:coupon) }

  it { should belong_to :merchant }
  it { should belong_to :customer }
  it { should validate_inclusion_of(:status).in_array(%w(shipped packaged returned)) }

  it { should belong_to(:coupon).optional }

  it "should validate uniqueness of coupon_id" do
    invoice1 = create(:invoice, coupon: coupon )

    expect(invoice1).to be_valid
  end
end