require "rails_helper"

describe Coupon, type: :model do
  describe 'validations' do
    it { should belong_to :merchant }
    it { should have_many :invoices }
  end
end