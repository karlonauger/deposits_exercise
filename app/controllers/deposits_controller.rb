class DepositsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  DEPOSIT_EXCEEDS_BALANCE = 'Deposit exceeds outstanding balance'.freeze

  def create
    tradeline = Tradeline.find(tradeline_id)
    unless tradeline.outstanding_balance >= deposit_params[:amount].to_f
      return render json: { error: DEPOSIT_EXCEEDS_BALANCE }, status: :unprocessable_entity
    end

    deposit = tradeline.deposits.build(deposit_params)
    if deposit.save
      render json: deposit, status: :created
    else
      render json: deposit.errors, status: :unprocessable_entity
    end
  end

  def index
    render json: Deposit.where(tradeline_id: tradeline_id)
  end

  def show
    render json: Deposit.find_by!(id: params[:id], tradeline_id: tradeline_id)
  end

  private

  def tradeline_id
    params.require(:tradeline_id)
  end

  def deposit_params
    params.require(:deposit).permit(:amount, :deposit_date)
  end

  def not_found
    render json: 'not_found', status: :not_found
  end
end
