require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "POST #create" do
    context "when email is invalid" do
      it "returns a failure" do
        user = create(:user)

        post :create,
          params: { session: { email: "a@b.c", password: user.password } }

        expect(response).to have_http_status :unauthorized
        expect(json[:success]).to eq false
      end
    end

    context "when password is invalid" do
      it "returns a failure" do
        user = create(:user)
        post :create,
          params: { session: { email: user.email, password: "invalid" } }

        expect(response).to have_http_status :unauthorized
        expect(json[:success]).to eq false
      end
    end

    context "when both are valid" do
      it "returns a token" do
        user = create(:user)

        post :create,
          params: { session: { email: user.email, password: user.password } }

        expect(response).to have_http_status :created
        expect(json[:success]).to be true
        expect(user_token_id(json[:token])).to eq user.id
      end
    end
  end

  describe "GET #test" do
    context "with an invalid token" do
      it "returns a failure" do
        get :test

        expect(response).to have_http_status :unauthorized
        expect(response.header["WWW-Authenticate"]).to \
          eq "Bearer realm=\"Application\""
        expect(json[:success]).to be false
      end
    end
  end

  context "with a valid token" do
    it "returns a success" do
      user = create(:user)
      token = create_user_token(user)
      request.headers["Authorization"] = "Bearer #{token}"
      get :test

      expect(response).to have_http_status :ok
      expect(json[:success]).to be true
    end
  end
end
