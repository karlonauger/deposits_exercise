class Tradeline < ApplicationRecord
  has_many :deposits

  validates :amount, presence: true, numericality: { greater_than: 0 }

  def outstanding_balance
    amount - deposits.sum(:amount)
  end
end
