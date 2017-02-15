require 'rails_helper'

RSpec.describe API::UsersController, type: :controller do
  describe "POST #create" do
    let(:data) { { user: user_data, format: :json } }
    let(:user_data) { { email: email_data,
        password: password_data,
        password_confirmation: password_confirmation_data } }
    let(:random) { build(:user) }
    let(:email_data) { random.email }
    let(:password_data) { random.password }
    let(:password_confirmation_data) { random.password }

    context "with an already existing email" do
      let(:user) { create(:user) }
      let(:email_data) { user.email }
      it "returns a failure" do
        post :create, params: data

        expect(response).to have_http_status :unprocessable_entity
        expect(json[:errors]).to be_a Hash
        expect(json[:errors]).to eq email: [{error: "taken", value: user.email}]
      end
    end

    context "with no confirmation" do
      let(:user_data) { { email: random.email, password: random.email } }
      it "returns a failure" do
        post :create, params: data

        expect(response).to have_http_status :unprocessable_entity
        expect(json[:errors]).to be_a Hash
        expect(json[:errors]).to eq password_confirmation: [{error: "blank"}]
      end
    end

    context "with an invalid confirmation" do
      let(:password_confirmation_data) { "invalid" }
      it "returns a failure" do
        post :create, params: data

        expect(response).to have_http_status :unprocessable_entity
        expect(json[:errors]).to be_a Hash
        expect(json[:errors]).to eq password_confirmation: [
          {error: "confirmation", attribute: "Password"},
          {error: "confirmation", attribute: "Password"}
        ]
      end
    end

    context "with valid data" do
      it "returns a success" do
        post :create, params: data

        expect(response).to have_http_status :created
        created = User.find_by(email: random.email)
        expect(created).to be_a User
        expect(user_token_id(json[:token])).to eq created.id
      end
    end
  end
end
