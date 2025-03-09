class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  enum status: { active: 'active', inactive: 'inactive' }

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :discount, presence: true
  validate :merchant_active_coupon_limit, if: :status_active?

  private

  def merchant_active_coupon_limit
    if merchant.coupons.active.count >= 5
      errors.add(:status, "Merchant already has 5 active coupons")
    end
  end

  def status_active?
    status == 'active'
  end
end