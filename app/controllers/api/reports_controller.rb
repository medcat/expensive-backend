class API::ReportsController < ApplicationController
  before_action :authenticate_request

  def index
    authorize
    @reports = policy_scope(Report).order(created_at: :DESC).page(params[:page])
    render :index
  end

  def show
    @report = Report.find(params[:id])
    authorize(@report)
    render :show
  end

  def update
    @report = Report.find(params[:id])
    authorize(@report)
    # TODO
  end

  def create
    @report = Report.find(params[:id])
    authorize(@report)
    # TODO
  end

  def destroy
    @report = Report.find(params[:id])
    authorize(@report)
    @expense.destroy!
    render json: {}, status: :no_content
  end
end
