require 'rails_helper'

RSpec.describe ExpensePolicy do

  let(:resource) { create(:expense) }
  let(:user) { resource.user }
  let(:admin) { create(:user, :admin)}
  let(:random) { create(:user) }
  subject { described_class }

  permissions ".scope" do
    pending
  end

  permissions :show? do
    it "grants access if user is owner" do
      expect(subject).to permit(user, resource)
    end

    it "grants access if user is admin" do
      expect(subject).to permit(admin, resource)
    end

    it "denies access otherwise" do
      expect(subject).to_not permit(random, resource)
    end
  end

  permissions :index?, :create? do
    it "always grants access" do
      expect(subject).to permit(user, resource)
      expect(subject).to permit(admin, resource)
      expect(subject).to permit(random, resource)
    end
  end

  permissions :update? do
    it "grants access if user is owner" do
      expect(subject).to permit(user, resource)
    end

    it "denies access even if user is admin" do
      expect(subject).to_not permit(admin, resource)
    end

    it "denies access to everyone else" do
      expect(subject).to_not permit(random, resource)
    end
  end

  permissions :destroy? do
    it "grants access if user is owner" do
      expect(subject).to permit(user, resource)
    end

    it "denies access even if user is admin" do
      expect(subject).to_not permit(admin, resource)
    end

    it "denies access to everyone else" do
      expect(subject).to_not permit(random, resource)
    end
  end
end
