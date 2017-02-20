require 'rails_helper'

RSpec.describe API::ReportsController, type: :controller do
  describe "POST #create" do
    let(:data) { { report: report_data, format: :json } }
    let(:report_data) {
      { name: "A Report",
        start: 3.weeks.ago.to_s,
        stop: 1.week.ago.to_s,
        currency: "USD" } }

    context "without authentication" do
      it "returns a failure" do
        post :create, params: data
        expect(response).to have_http_status :unauthorized
      end
    end

    context "with authentication" do
      let(:user) { create(:user) }
      let(:token) { create_user_token(user) }
      before { request.headers["Authorization"] = "Bearer #{token}" }

      context "with no data" do
        let(:report_data) { {} }

        it "returns a failure" do
          post :create, params: data
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context "with invalid data" do
        let(:report_data) { { name: "" } }

        it "returns a failure" do
          post :create, params: data
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context "with valid data" do
        it "returns a success" do
          post :create, params: data
          expect(response).to have_http_status :created
        end
      end
    end
  end

  describe "PUT #update" do
    let(:original) { create(:report) }
    let(:user) { original.user }
    let(:token) { create_user_token(user) }
    let(:data) { { id: original.id, report: report_data, format: :json } }
    let(:start) { 4.weeks.ago.to_s }
    let(:report_data) { { start: start } }

    context "without authentication" do
      it "fails" do
        put :update, params: data
        expect(response).to have_http_status :unauthorized
      end
    end

    context "with authentication" do
      before { request.headers["Authorization"] = "Bearer #{token}" }
      context "as owner" do
        it "succeeds" do
          put :update, params: data
          expect(response).to have_http_status :ok
          original.reload
          expect(original.start.to_s).to eq start
        end

        context "with bad data" do
          let(:start) { "aaaa" }

          it "fails" do
            put :update, params: data
            expect(response).to have_http_status :unprocessable_entity
            original.reload
            expect(original.start.to_s).to_not eq start
          end
        end
      end

      context "as admin" do
        let(:user) { create(:user, :admin) }

        it "fails" do
          put :update, params: data
          expect(response).to have_http_status :not_found
          original.reload
          expect(original.start.to_s).to_not eq start
        end
      end

      context "as a random" do
        let(:user) { create(:user) }

        it "fails" do
          put :update, params: data
          expect(response).to have_http_status :not_found
          original.reload
          expect(original.start).to_not eq start
        end
      end
    end
  end

  describe "GET #show" do
    let(:report) { create(:report) }
    let(:user) { report.user }
    let(:token) { create_user_token(user) }
    let(:data) { { id: report.id, format: :json } }

    it "fails for an invalid token" do
      get :show, params: data
      expect(response).to have_http_status :unauthorized
    end

    it "retrieves the resource" do
      request.headers["Authorization"] = "Bearer #{token}"
      get :show, params: data
      expect(response).to have_http_status :ok
    end

    context "with the wrong id" do
      let(:data) { { id: "0000", format: :json } }

      it "fails" do
        request.headers["Authorization"] = "Bearer #{token}"
        get :show, params: data
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe "GET #index" do
    let(:data) { { format: :json } }
    let(:user) { create(:user) }
    let(:reports) { create_list(:report, 50, user: user) }
    let(:token) { create_user_token(user) }

    context "without a token" do
      it "fails" do
        get :index, params: data
        expect(response).to have_http_status :unauthorized
      end
    end

    context "with a token" do
      before { request.headers["Authorization"] = "Bearer #{token}" }
      before { reports }

      it "succeeds" do
        get :index, params: data
        expect(response).to have_http_status :ok
      end

      context "as an admin" do
        let(:admin) { create(:user, :admin) }
        let(:token) { create_user_token(admin) }
        before { create(:report, user: admin) }

        context "without all" do
          it "lists only owned" do
            get :index, params: data
            expect(response).to have_http_status :ok
            expect(response).to render_template "api/reports/index"
          end
        end

        context "with all" do
          let(:data) { { all: true, format: :json } }

          it "still lists only owned" do
            get :index, params: data
            expect(response).to have_http_status :ok
            expect(response).to render_template "api/reports/index"
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "with a valid id" do
      let(:report) { create(:report) }
      let(:token) { create_user_token(report.user) }
      let(:data) { { id: report.id, format: :json } }
      before { request.headers["Authorization"] = "Bearer #{token}" }

      context "as owner" do
        it "works" do
          delete :destroy, params: data
          expect(response).to have_http_status :no_content
        end
      end

      context "as admin" do
        let(:admin) { create(:user, :admin) }
        let(:token) { create_user_token(admin) }

        it "fails" do
          delete :destroy, params: data
          expect(response).to have_http_status :not_found
        end
      end

      context "as a random" do
        let(:random) { create(:user) }
        let(:token) { create_user_token(random) }

        it "fails" do
          delete :destroy, params: data
          expect(response).to have_http_status :not_found
        end
      end
    end

    context "with an invalid id" do
      let(:report) { create(:report) }
      let(:token) { create_user_token(report.user) }
      let(:data) { { id: "apples", format: :json } }
      before { request.headers["Authorization"] = "Bearer #{token}" }

      it "fails" do
        delete :destroy, params: data
        expect(response).to have_http_status :not_found
      end
    end
  end
end
