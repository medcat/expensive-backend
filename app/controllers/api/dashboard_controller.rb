# encoding: utf-8

class API::DashboardController < ApplicationController
  before_action :authenticate_request
  def index
    @expenses = policy_scope(Expense)
    @expenses = @expenses.where(user: current_user) \
      unless params[:all] && current_user.admin?
    render :index
  end
end
