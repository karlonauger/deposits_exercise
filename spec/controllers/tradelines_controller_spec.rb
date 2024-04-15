require 'rails_helper'

RSpec.describe TradelinesController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }

  describe '#index' do
    let!(:tradeline) { FactoryBot.create :tradeline }
    let!(:other_tradeline) { FactoryBot.create :tradeline }

    it 'responds with a 200' do
      get :index

      expect(response).to have_http_status(:ok)
    end

    it 'returns all tradelines' do
      get :index

      expected_response = [tradeline, other_tradeline].as_json(
        only: [:id, :amount, :created_at, :updated_at, :name],
        methods: [:outstanding_balance]
      )
      expect(json_response).to eq(expected_response)
    end
  end

  describe '#show' do
    let(:tradeline) { FactoryBot.create :tradeline }
    let(:params) { { id: tradeline.id } }

    context 'when the loan is found' do
      it 'responds with a 200' do
        get :show, params: params

        expect(response).to have_http_status(:ok)
      end

      it 'returns the tradeline' do
        get :show, params: params

        expected_response = tradeline.as_json(
          only: [:id, :amount, :created_at, :updated_at, :name],
          methods: [:outstanding_balance]
        )
        expect(json_response).to eq(expected_response)
      end
    end

    context 'when the loan is not found' do
      it 'responds with a 404' do
        get :show, params: { id: 1000 }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
