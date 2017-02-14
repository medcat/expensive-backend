require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "POST #create" do
    context "when email is invalid" do
      it "returns a failure" do
        user = create(:user)

        post :create,
          params: { session: { email: "a@b.c", password: user.password } }

        expect(response).to have_http_status :unauthorized
        expect(JSON.load(response.body)).to eq "success" => false
      end
    end

    context "when password is invalid" do
      it "returns a failure" do
        user = create(:user)
        post :create,
          params: { session: { email: user.email, password: "invalid" } }

        expect(response).to have_http_status :unauthorized
        expect(JSON.load(response.body)).to eq "success" => false
      end
    end

    context "when both are valid" do
      it "returns a token" do
        user = create(:user)

        post :create,
          params: { session: { email: user.email, password: user.password } }

        expect(response).to have_http_status :created
        body = JSON.load(response.body)
        expect(body["success"]).to be true
        secret = Rails.application.secrets.jwt_secret
        payload, = JWT.decode(body["token"], secret, true, algorithm: "HS256")
        expect(payload["id"]).to eq user.id
      end
    end
  end
end
