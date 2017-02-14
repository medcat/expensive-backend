require 'rails_helper'

RSpec.describe API::ExpensesController, type: :controller do
  # Note that the logic for validation is tested in
  # services/create_expense_service_spec.rb, and so we only do a small test
  # run for the expected response on a failure.

  describe "POST #create" do
    let(:data) { { expense: expense_data, format: :json } }
    let(:expense_data) { { amount: "10.00", currency: "USD", time: "Fri, 14 Aug 2015 08:40:39 UTC +00:00" } }

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
        let(:expense_data) { {} }

        it "returns a failure" do
          post :create, params: data
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context "with invalid data" do
        let(:expense_data) { { amount: "0.0" } }

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
    let(:original) { create(:expense) }
    let(:user) { original.user }
    let(:token) { create_user_token(user) }
    let(:data) { { id: original.id, expense: expense_data, format: :json } }
    let(:description) { "foo bar" }
    let(:expense_data) { { description: description } }

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
          expect(original.description).to eq description
        end
      end

      context "as admin" do
        let(:user) { create(:user, :admin) }

        it "fails" do
          put :update, params: data
          expect(response).to have_http_status :not_found
          original.reload
          expect(original.description).to_not eq description
        end
      end

      context "as a random" do
        let(:user) { create(:user) }

        it "fails" do
          put :update, params: data
          expect(response).to have_http_status :not_found
          original.reload
          expect(original.description).to_not eq description
        end
      end
    end
  end

  describe "GET #show" do
    let(:expense) { create(:expense) }
    let(:user) { expense.user }
    let(:token) { create_user_token(user) }
    let(:data) { { id: expense.id, format: :json } }

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
    let(:expenses) { create_list(:expense, 50, user: user) }
    let(:token) { create_user_token(user) }

    context "without a token" do
      it "fails" do
        get :index, params: data
        expect(response).to have_http_status :unauthorized
      end
    end

    context "with a token" do
      before { request.headers["Authorization"] = "Bearer #{token}" }
      before { expenses }

      it "succeeds" do
        get :index, params: data
        expect(response).to have_http_status :ok
      end

      context "as an admin" do
        let(:admin) { create(:user, :admin) }
        let(:token) { create_user_token(admin) }

        context "without all" do
          it "lists only owned" do
            get :index, params: data
            expect(response).to have_http_status :ok
            expect(json[:data]).to be_empty
          end
        end

        context "with all" do
          let(:data) { { all: true, format: :json } }

          it "lists all" do
            get :index, params: data
            expect(response).to have_http_status :ok
            expect(json[:data]).to_not be_empty
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "with a valid id" do
      let(:expense) { create(:expense) }
      let(:token) { create_user_token(expense.user) }
      let(:data) { { id: expense.id, format: :json } }
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
      let(:expense) { create(:expense) }
      let(:token) { create_user_token(expense.user) }
      let(:data) { { id: "apples", format: :json } }
      before { request.headers["Authorization"] = "Bearer #{token}" }

      it "fails" do
        delete :destroy, params: data
        expect(response).to have_http_status :not_found
      end
    end
  end
end
