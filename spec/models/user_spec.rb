require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(data) }

  let(:data) {
    { email: email_data,
      password: password_data,
      password_confirmation: confirmation_data } }
  let(:email_data) { "test@example.com" }
  let(:password_data) { "SomeAwesomePassword" }
  let(:confirmation_data) { password_data }

  context "with invalid data" do
    context "with no email" do
      let(:email_data) { nil }
      it { is_expected.to_not be_valid }
    end

    context "with an invalid email" do
      let(:email_data) { "invalid" }
      it { is_expected.to_not be_valid }
    end

    context "with no password" do
      let(:password_data) { nil }
      it { is_expected.to_not be_valid }
    end

    context "with an invalid password" do
      let(:password_data) { "abc" }
      it { is_expected.to_not be_valid }
    end

    context "with no password confirmation" do
      let(:confirmation_data) { nil }
      it { is_expected.to_not be_valid }
    end

    context "with a non-matching password confirmation" do
      let(:confirmation_data) { "abc" }
      it { is_expected.to_not be_valid }
    end
  end

  context "with valid data" do
    it { is_expected.to be_valid }
  end
end
