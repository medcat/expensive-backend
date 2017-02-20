class API::ReportsController < ApplicationController
  before_action :authenticate_request

  def index
    authorize(Report)
    @reports = policy_scope(Report).order(created_at: :DESC).page(params[:page])
    render :index
  end

  ALLOWED_PERIODS = %w[hour day week month year].freeze

  def show
    @report = Report.find(params[:id])
    authorize(@report)
    @expenses = scope_with_params(@report.expenses)
    @period = ALLOWED_PERIODS.include?(params[:period]) ? params[:period] : "week"
    render :show
  end

  def create
    @report = Report.new(report_parameters)
    @report.user = current_user
    authorize(@report)

    if @report.save
      render :show, status: :created, location: api_report_path(@report)
    else
      render json: { errors: @report.errors.details },
        status: :unprocessable_entity
    end
  end

  def update
    @report = Report.find(params[:id])
    authorize(@report)

    if @report.update(report_parameters)
      render :show, status: :ok, location: api_report_path(@report)
    else
      render json: { errors: @report.errors.details },
        status: :unprocessable_entity
    end
  end

  def destroy
    @report = Report.find(params[:id])
    authorize(@report)
    @report.destroy!
    render json: {}, status: :no_content
  end

private

  def report_parameters
    params.require(:report).permit(:start, :stop, :name, :currency)
  end

  def scope_with_params(expenses)
    return expenses unless params[:start] && params[:stop]
    start = ::DateTime.parse(params[:start])
    stop = ::DateTime.parse(params[:stop])
    return expenses if stop < start
    expenses.where("time BETWEEN ? AND ?", start, stop)
  rescue
    expenses
  end
end
