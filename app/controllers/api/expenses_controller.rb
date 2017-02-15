class API::ExpensesController < ApplicationController
  before_action :authenticate_request

  def index
    # authorize(Expense)
    # @expenses = policy_scope(Expense)
    @expenses = Expense.all
    # Only list all of the expenses when it's requested.
    unless params[:all] && current_user.admin?
      @expenses = @expenses.where(user: current_user)
    end

    @expenses = @expenses.order(time: :DESC).page(params[:page])

    render "api/expenses/index", formats: :json
  end

  def show
    @expense = Expense.find(params[:id])
    authorize @expense
    render json: @expense
  end

  def destroy
    @expense = Expense.find(params[:id])
    authorize @expense
    @expense.destroy!
    head :no_content
  end

  def create
    @expense = CreateExpenseService.new(expense_parameters)
    authorize @expense

    if result = @expense.save
      render json: @expense, status: :created,
        location: api_expense_path(id: result)
    else
      render json: { errors: @expense.errors.details },
        status: :unprocessable_entity
    end
  end

  def update
    @expense = UpdateExpenseService.new(expense_update_parameters)
    authorize @expense

    if result = @expense.save
      render json: @expense, status: :ok, location: api_expense_path(id: result)
    else
      render json: { errors: @expense.errors.details },
        status: :unprocessable_entity
    end
  end

  private

  def expense_update_parameters
    expense_parameters.merge(id: params[:id])
  end

  def expense_parameters
    expense_params.merge(user: current_user)
  end

  def expense_params
    params.require(:expense).permit(:amount, :currency, :time, :description)
  end
end
