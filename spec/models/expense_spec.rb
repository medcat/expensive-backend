require 'rails_helper'

RSpec.describe Expense, type: :model do
  subject { described_class.new(data) }

  let(:data) {
    { user: user_data,
      amount: amount_data,
      amount_currency: currency_data,
      time: time_data,
      description: description_data } }
  let(:user_data) { create(:user) }
  let(:amount_data) { 10.00 }
  let(:currency_data) { "USD" }
  let(:time_data) { DateTime.parse("Fri, 14 Aug 2015 08:40:39 UTC +00:00") }
  let(:description_data) { "hello, world" }

  context "with invalid data" do
    context "with no user" do
      let(:user_data) { nil }
      it { is_expected.to_not be_valid }
    end

    context "with no amount" do
      let(:amount_data) { nil }
      it { is_expected.to_not be_valid }
    end

    context "with invalid amount data" do
      let(:amount_data) { "Asdf" }
      it { is_expected.to_not be_valid }
    end

    context "with an invalid currency" do
      let(:currency_data) { "UUU" }
      it { is_expected.to_not be_valid }
    end

    context "with no time" do
      let(:time_data) { nil }
      it { is_expected.to_not be_valid }
    end

    context "with an invalid time" do
      let(:time_data) { "Asdfasdfasdf" }
      it { is_expected.to_not be_valid }
    end
  end

  context "with valid data" do
    it { is_expected.to be_valid }
    it "saves a record" do
      expect(subject.save).to be true
    end

    it "saves a record correctly" do
      expect(subject.save).to be true
      expect(subject.amount).to eq Money.from_amount(amount_data, currency_data)
      expect(subject.user).to eq user_data
    end

    context "with a string time" do
      let(:time_data) { "Fri, 14 Aug 2015 08:40:39 UTC +00:00" }
      it { is_expected.to be_valid }
    end

    context "with a string amount" do
      let(:amount_data) { "10.00" }
      it "sets the right amount" do
        expect(subject.amount).to eq Money.from_amount(amount_data.to_f, currency_data)
      end
    end
  end
end
