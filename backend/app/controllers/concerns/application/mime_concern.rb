module Application
  module MimeConcern
    extend ActiveSupport::Concern

    included do
      before_action :validate_mime_type
    end

    private

    def validate_mime_type
      return request.format = :json if request.formats.include?(:json) ||
        request.formats.none?

      head :not_acceptable
    end
  end
end
