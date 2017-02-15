module Support
  module JsonHelper
    def json
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end

RSpec.configure do |config|
  config.include Support::JsonHelper, type: :controller
end
