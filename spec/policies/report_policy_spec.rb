require 'rails_helper'

RSpec.describe ReportPolicy do

  let(:resource) { create(:report) }
  let(:user) { resource.user }
  let(:admin) { create(:user, :admin) }
  let(:random) { create(:user) }

  subject { described_class }

  permissions ".scope" do
    subject { described_class::Scope.new(actor, resource.class) }

    context "when scoping for a user" do
      let(:actor) { random }

      it "resolves properly" do
        expect(subject.resolve.where_values_hash).to eq("user_id" => actor.id)
      end
    end

    context "when scoping for an admin" do
      let(:actor) { admin }

      it "resolves properly" do
        expect(subject.resolve.where_values_hash).to eq("user_id" => actor.id)
      end
    end
  end

  permissions :show? do
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
