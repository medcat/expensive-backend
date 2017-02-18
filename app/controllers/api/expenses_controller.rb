class API::ExpensesController < ApplicationController
  before_action :authenticate_request

  def index
    authorize(Expense)
    @expenses = policy_scope(Expense)
    # Only list all of the expenses when it's requested.
    unless params[:all] && current_user.admin?
      @expenses = @expenses.where(user: current_user)
    end

    @expenses = @expenses.order(time: :DESC).page(params[:page])

    render :index
  end

  def show
    @expense = Expense.find(params[:id])
    authorize @expense
    render :show
  end

  def destroy
    @expense = Expense.find(params[:id])
    authorize @expense
    @expense.destroy!
    render json: {}, status: :no_content
  end

  def create
    @expense = Expense.new(expense_parameters)
    @expense.user = current_user
    authorize @expense

    if @expense.save
      render :show, status: :created,
        location: api_expense_path(id: @expense)
    else
      render json: { errors: @expense.errors.details },
        status: :unprocessable_entity
    end
  end

  def update
    @expense = Expense.find(params[:id])
    authorize @expense

    if result = @expense.update(expense_parameters)
      @expense = result
      render :show, status: :ok, location: api_expense_path(id: @expense)
    else
      render json: { errors: @expense.errors.details },
        status: :unprocessable_entity
    end
  end

  private

  def expense_parameters
    expense = params.require(:expense)
    data = {}
    { amount: :amount_unit, currency: :amount_currency, time: :time,
      description: :description }.each do |given, actual|
      data[actual] = expense[given] if expense[given]
    end

    data
  end
end
