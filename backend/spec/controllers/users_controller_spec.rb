require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "POST #create" do
    context "with an already existing email" do
      it "returns a failure" do
        user = create(:user)

        post :create,
          params: { user: { email: user.email, password: "password",
            password_confirmation: "password"} }

        expect(response).to have_http_status :bad_request
        expect(json[:success]).to be false
        expect(json[:errors]).to be_a Hash
        expect(json[:errors]).to eq email: [{error: "taken", value: user.email}]
      end
    end

    context "with no confirmation" do
      it "returns a failure" do
        user = build(:user)

        post :create,
          params: { user: { email: user.email, password: user.password } }

        expect(response).to have_http_status :bad_request
        expect(json[:success]).to be false
        expect(json[:errors]).to be_a Hash
        expect(json[:errors]).to eq password_confirmation: [{error: "blank"}]
      end
    end

    context "with an invalid confirmation" do
      it "returns a failure" do
        user = build(:user)

        post :create,
          params: { user: { email: user.email, password: user.password,
            password_confirmation: "invalid" } }

        expect(response).to have_http_status :bad_request
        expect(json[:success]).to be false
        expect(json[:errors]).to be_a Hash
        expect(json[:errors]).to eq password_confirmation: [
          {error: "confirmation", attribute: "Password"},
          {error: "confirmation", attribute: "Password"}
        ]
      end
    end

    context "with valid data" do
      it "returns a success" do
        user = build(:user)

        post :create,
          params: { user: { email: user.email, password: user.password,
            password_confirmation: user.password } }

        expect(response).to have_http_status :created
        expect(json[:success]).to be true
        created = User.find_by(email: user.email)
        expect(created).to be_a User
        expect(user_token_id(json[:token])).to eq created.id
      end
    end
  end
end
