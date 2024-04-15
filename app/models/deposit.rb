class Deposit < ApplicationRecord
  belongs_to :tradeline

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :deposit_date, presence: true
end
