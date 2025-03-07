class Coupon < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true
  validates :discount, presence: true
  belongs_to :merchant

end