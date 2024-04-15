require 'rails_helper'

RSpec.describe Tradeline, type: :model do
  describe '#outstanding_balance' do
    context 'with no deposits' do
      it 'calculates the outstanding balance correctly' do
        tradeline = FactoryBot.create(:tradeline, amount: 1000)
        
        expect(tradeline.outstanding_balance).to eq(1000)
      end
    end

    context 'with one deposit' do
      it 'calculates the outstanding balance correctly' do
        tradeline = FactoryBot.create(:tradeline, amount: 1000)
        FactoryBot.create(:deposit, tradeline: tradeline, amount: 200)

        expect(tradeline.outstanding_balance).to eq(800)
      end
    end

    context 'with multiple deposits' do
      it 'calculates the outstanding balance correctly' do
        tradeline = FactoryBot.create(:tradeline, amount: 1000)
        FactoryBot.create(:deposit, tradeline: tradeline, amount: 200)
        FactoryBot.create(:deposit, tradeline: tradeline, amount: 300)

        expect(tradeline.outstanding_balance).to eq(500)
      end
    end

    context 'with multiple deposits exceeding balance' do
      it 'calculates the outstanding balance correctly' do
        tradeline = FactoryBot.create(:tradeline, amount: 1000)
        FactoryBot.create(:deposit, tradeline: tradeline, amount: 500)
        FactoryBot.create(:deposit, tradeline: tradeline, amount: 600)

        expect(tradeline.outstanding_balance).to eq(-100)
      end
    end
  end
end
