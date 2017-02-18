require 'rails_helper'

RSpec.describe Report, type: :model do
  subject { described_class.new(data) }

  let(:data) {
    { user: user_data,
      start: start_data,
      stop: stop_data,
      name: name_data
    } }
  let(:user_data) { create(:user) }
  let(:start_data) { 3.weeks.ago }
  let(:stop_data) { 1.week.ago }
  let(:name_data) { "A Report" }

  context "with invalid data" do
    context "with no user" do
      let(:user_data) { nil }
      it { is_expected.to_not be_valid }
    end

    context "with no start date" do
      let(:start_data) { nil }
      it { is_expected.to_not be_valid }
    end

    context "with an incorrectly formatted start date" do
      let(:start_data) { "Asdfasdfasdf" }
      it { is_expected.to_not be_valid }
    end

    context "with an incorrectly positioned start date" do
      let(:start_data) { 1.minute.ago } # Places it forward of the stop date
      it { is_expected.to_not be_valid }
    end

    context "with no stop date" do
      let(:stop_data) { nil }
      it { is_expected.to_not be_valid }
    end

    context "with an incorrectly formatted stop date" do
      let(:stop_data) { "Asdfasdfasdf" }
      it { is_expected.to_not be_valid }
    end

    context "with an incorrectly positioned stop date" do
      let(:stop_data) { 4.weeks.ago } # Places it after the start date
      it { is_expected.to_not be_valid }
    end

    context "with no name" do
      let(:name_data) { nil }
      it { is_expected.to_not be_valid }
    end

    context "with a short name" do
      let(:name_data) { "a" }
      it { is_expected.to_not be_valid }
    end

    context "with a long name" do
      let(:name_data) { "x" * 121 }
      it { is_expected.to_not be_valid }
    end
  end

  context "with valid data" do
    it { is_expected.to be_valid }

    context "with a string start date" do
      let(:start_data) { 1.week.ago.to_s }
      it { is_expected.to be_valid }
    end

    context "with a string stop date" do
      let(:stop_data) { 1.week.ago.to_s }
      it { is_expected.to be_valid }
    end
  end

  context "when loading expenses" do
    let(:user) { create(:user) }
    let(:report) { create(:report, user: user) }
    let(:expenses) { create_list(:expense, 10, user: user) }
    before { expenses }

    it "does not error" do
      expect(report.expenses.size).to be 10
    end

    it "matches the ids" do
      expect(report.expense_ids).to eq expenses.map(&:id)
    end
  end
end
