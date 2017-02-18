class ReportPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    true
  end

  def show?
    super && owns_resource?
  end

  def owns_resource?
    @record.user == @user
  end

  alias_method :update?, :owns_resource?
  alias_method :destroy?, :owns_resource?

  class Scope < Scope
    def resolve
      super.where(user: @user)
    end
  end
end
