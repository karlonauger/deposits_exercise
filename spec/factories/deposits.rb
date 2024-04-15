# frozen_string_literal: true

FactoryBot.define do
  factory :deposit do
    amount { 9.99 }
    deposit_date { '2024-04-15' }
    tradeline { tradeline }
  end
end
