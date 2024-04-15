require 'rails_helper'

RSpec.describe DepositsController, type: :controller do
  let(:tradeline) { FactoryBot.create(:tradeline, amount: 1000) }
  let(:json_response) { JSON.parse(response.body) }

  describe '#create' do
    let(:amount) { 200 }
    let(:params) do
      { tradeline_id: tradeline.id, deposit: { amount: amount, deposit_date: Date.today } }
    end

    context 'when the deposit is valid' do
      context 'when the deposit saves' do
        it 'responds with a 200' do
          post :create, params: params
    
          expect(response).to have_http_status(:created)
        end

        it 'creates a new deposit' do
          post :create, params: params

          expect(tradeline.deposits.count).to eq(1)
        end
      end

      context 'when the deposit fails to save' do
        before do
          allow_any_instance_of(Deposit).to receive(:save).and_return(false)
          allow_any_instance_of(Deposit).to receive(:errors).and_return({base: ["an error occurred"]})
        end
  
        it 'returns an unprocessable entity status with errors' do
          post :create, params: params

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq({"base" => ["an error occurred"]})
        end
      end
    end

    context 'when the deposit exceeds the outstanding balance' do
      let(:amount) { 1200 }

      it 'returns an error' do
        post :create, params: params
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to include(DepositsController::DEPOSIT_EXCEEDS_BALANCE)
      end

      it 'does not create a deposit' do
        post :create, params: params
        
        expect(tradeline.deposits.count).to eq(0)
      end
    end
  end

  describe '#index' do
    let!(:deposit) { FactoryBot.create(:deposit, { tradeline: tradeline }) }
    let!(:other_deposit) { FactoryBot.create(:deposit, { tradeline: tradeline }) }
    let(:params) { { tradeline_id: tradeline.id } }

    it 'responds with a 200' do
      get :index, params: params

      expect(response).to have_http_status(:ok)
    end

    it 'returns all tradelines' do
      get :index, params: params

      expected_response = [deposit, other_deposit]
        .as_json(only: [:id, :amount, :created_at, :updated_at, :deposit_date, :tradeline_id])
      expect(json_response).to eq(expected_response)
    end
  end

  describe '#show' do
    let(:deposit) { FactoryBot.create(:deposit, { tradeline: tradeline }) }

    context 'when the loan is found' do
      it 'responds with a 200' do
        get :show, params: { tradeline_id: tradeline.id, id: deposit.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the loan is not found' do
      it 'responds with a 404' do
        get :show, params: { tradeline_id: tradeline.id, id: 1000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
