require "rails_helper"

RSpec.describe UpdateExpenseService, type: :service do
  subject { UpdateExpenseService.new(data) }
  let(:user) { create(:user) }
  let(:original) { create(:expense, user: user) }
  let(:data) {
    { id: original.id,
      amount: amount_data,
      currency: currency_data,
      time: time_data,
      description: description_data } }
  let(:amount_data) { "10.00" }
  let(:currency_data) { "USD" }
  let(:time_data) { DateTime.parse("Fri, 14 Aug 2015 08:40:39 UTC +00:00") }
  let(:description_data) { "hello, world" }

  context "with invalid data" do
    context "with no amount" do
      let(:amount_data) { nil }
      it { is_expected.to be_valid }
    end

    context "with invalid amount data" do
      let(:amount_data) { "Asdf" }
      it { is_expected.to_not be_valid }
    end

    context "with no currency" do
      let(:currency_data) { nil }
      it { is_expected.to be_valid }
    end

    context "with an invalid currency" do
      let(:currency_data) { "UUU" }
      it { is_expected.to_not be_valid }
    end

    context "with no time" do
      let(:time_data) { nil }
      it { is_expected.to be_valid }
    end

    context "with an invalid time" do
      let(:time_data) { "Asdfasdfasdf" }
      it { is_expected.to_not be_valid }
    end
  end

  context "with valid data" do
    it { is_expected.to be_valid }
    it "creates a record" do
      record = subject.save
      expect(record).to be_an Expense
      expect(record.id).to_not be_nil
    end

    it "creates the right money amount" do
      expect(subject.value).to eq Money.new(1000, "USD")
    end

    context "with a string time" do
      let(:time_data) { "Fri, 14 Aug 2015 08:40:39 UTC +00:00" }
      it { is_expected.to be_valid }
    end
  end
end
