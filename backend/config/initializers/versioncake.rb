VersionCake.setup do |config|
  # Versioned Resources
  # Define what server resources are supported, deprecated or obsolete
  # Resources listed are priority based upon creation. To version all
  # resources you can define a catch all at the bottom of the block.
  VERSIONS = [1]
  LATEST_VERSION = 1
  config.resources do |r|
    # r.resource uri_regex, obsolete, deprecated, supported
    r.resource %r{\A/api}, [], [], VERSIONS
  end

  # [:http_accept_parameter, :http_header, :request_parameter, :path_parameter,
  #  :query_parameter]
  config.extraction_strategy =
    [:http_header, :request_parameter, :query_parameter]
  config.missing_version = LATEST_VERSION
  config.rails_view_versioning = true
  config.response_strategy = [:http_header]
end
