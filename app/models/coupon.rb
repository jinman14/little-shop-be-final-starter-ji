class Coupon < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true
  validates :discount, presence: true
  belongs_to :merchant
  has_many :invoices
  
  enum status: { active: 'active', inactive: 'inactive' }
end