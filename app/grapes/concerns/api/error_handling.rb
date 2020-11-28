module Api
  # Api Error Handling Module
  module ErrorHandling
    extend ActiveSupport::Concern

    included do
      helpers do
        def default_headers
          {
            'Content-Type' => 'application/json',
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Request-Method' => '*'
          }
        end

        def trace_response(ex, status, _loglevel = :debug)
          body = { error: ex.class.name, message: ex.message }
          body[:trace] = ex.backtrace unless Rails.env.production?
          rack_response(body.to_json, status, default_headers)
        end

        # response 400
        #
        # @param [Any] errors エラー内容
        def bad_request(errors)
          error!(errors.to_json, 400)
        end

        # response 404
        #
        # @param [Any] errors エラー内容
        def not_found(errors)
          error!(errors.to_json, 404)
        end
      end

      rescue_from :all do |ex|
        trace_response(ex, 500, :fatal)
      end

      rescue_from ActiveRecord::RecordInvalid do |ex|
        trace_response(ex, 422)
      end

      rescue_from ActiveRecord::RecordNotFound do |ex|
        trace_response(ex, 404)
      end

      rescue_from Fs::Multidb::Exceptions::NoDatabaseError do |ex|
        trace_response(ex, 404)
      end

      rescue_from ArgumentError do |ex|
        trace_response(ex, 400)
      end

      rescue_from Grape::Exceptions::ValidationErrors do |ex|
        body = { error: ex.class.name, message: ex.message, messages: ex.errors }
        rack_response(body.to_json, 400, default_headers)
      end

      route :any, '*path' do
        error!('no route', 404)
      end
    end
  end
end
