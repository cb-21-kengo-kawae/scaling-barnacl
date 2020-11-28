require 'grape'
require 'grape-swagger'

module Api
  # API Root
  class Root < Grape::API
    include Fs::Zeldalogging::ZeldaGrapeLogging
    version :v1, using: :header, vendor: 'zelda-template4th'
    format :json
    default_error_formatter :json
    content_type :json, 'application/json'

    # fs-resourcekeeper のコンシューマーアウトラインを提供するAPIを生成してマウントする
    mount(
      Fs::Resourcekeeper::Apis::GrapeSupport
      .define_consumer_outline_api(api_extensions: Authorizable)
    )

    mount AccountDbConnectionsApi

    add_swagger_documentation(
      base_path: '/template4th/api'
    )
  end
end
