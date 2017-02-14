# encoding: utf-8

module Application
  module ErrorConcern
    extend ActiveSupport::Concern

    included do
      rescue_from ::StandardError, with: :general_error
      rescue_from ::ActionController::ParameterMissing,
        with: :missing_parameter_error
      rescue_from ::VersionCake::UnsupportedVersionError,
        ::VersionCake::ObsoleteVersionError, ::VersionCake::MissingVersionError,
        with: :invalid_version_error
      rescue_from ::Pundit::NotAuthorizedError, with: :unauthorized_error
      rescue_from ::ActiveRecord::RecordNotFound, with: :missing_error
    end

  private

    def missing_parameter_error(exp)
      render json: {}, status: :unprocessable_entity
    end

    def invalid_version_error(exp)
      render json: {}, status: 418
    end

    def unauthorized_error
      render json: {}, status: :not_found
    end

    def missing_error
      render json: {}, status: :not_found
    end

    def general_error(exp)
      if Rails.env.production?
        render json: {}, status: :internal_server_error
      else
        render json: {
          success: false,
          class: exp.class.to_s,
          message: exp.message,
          backtrace: exp.backtrace
        }, status: :internal_server_error
      end
    end
  end
end
