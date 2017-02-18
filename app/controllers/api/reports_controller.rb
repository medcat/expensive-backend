class API::ReportsController < ApplicationController
  before_action :authenticate_request

  def index
    authorize(Report)
    @reports = policy_scope(Report).order(created_at: :DESC).page(params[:page])
    render :index
  end

  def show
    @report = Report.find(params[:id])
    authorize(@report)
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
    params.require(:report).permit(:start, :stop, :name)
  end
end
