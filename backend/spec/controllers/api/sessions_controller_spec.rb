require "rails_helper"

RSpec.describe API::SessionsController, type: :controller do
  describe "POST #create" do
    let(:data) { { session: session_data, format: :json } }
    let(:session_data) { { email: email_data, password: password_data } }
    let(:random) { create(:user) }
    let(:email_data) { random.email }
    let(:password_data) { random.password }
    context "when email is invalid" do
      let(:email_data) { "a@b.c" }
      it "returns a failure" do
        post :create, params: data
        expect(response).to have_http_status :not_found
      end
    end

    context "when password is invalid" do
      let(:password_data) { "invalid"}
      it "returns a failure" do
        post :create, params: data
        expect(response).to have_http_status :not_found
      end
    end

    context "when both are valid" do
      it "returns a token" do
        post :create, params: data
        expect(response).to have_http_status :created
        expect(user_token_id(json[:token])).to eq random.id
      end
    end
  end

  describe "GET #test" do
    context "with an invalid token" do
      it "returns a failure" do
        get :test, params: { format: :json }

        expect(response).to have_http_status :unauthorized
        expect(response.header["WWW-Authenticate"]).to \
          eq "Bearer realm=\"Application\""
      end
    end

    context "with a valid token" do
      it "returns a success" do
        user = create(:user)
        token = create_user_token(user)
        request.headers["Authorization"] = "Bearer #{token}"
        get :test, params: { format: :json }
        expect(response).to have_http_status :ok
      end
    end
  end
end
