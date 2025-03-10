class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  enum status: { active: 'active', inactive: 'inactive' }

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :discount, presence: true
  validate :active_coupon_limit, if: :status_active?

  def usage_count
    invoices.where(coupon_id: self.id).count
  end

  def self.coupon_activity_by_merchant(merchant, activity = nil)
    if activity.present?
      where(merchant: merchant, status: activity)
    else
      where(merchant: merchant)
    end
  end

  private

  def active_coupon_limit
    if merchant.coupons.active.count >= 5
      errors.add(:status, "Merchant already has 5 active coupons")
    end
  end

  def status_active?
    status == 'active'
  end
end