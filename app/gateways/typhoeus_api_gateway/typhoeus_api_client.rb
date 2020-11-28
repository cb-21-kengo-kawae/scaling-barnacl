module TyphoeusApiGateway
  # 各サービスへのAPIリクエストを行う基底クラス
  class TyphoeusApiClient
    attr_accessor :retry_intervals

    RETRY_INTERVALS = [1, 2, 4, 8].freeze

    def initialize(logger = nil)
      @logger = logger || Fs::Zeldalogging.logger
      @retry_intervals ||= RETRY_INTERVALS
    end

    def get(uri, params = {})
      ret = single_request(uri, :get, params: params)
      ret.handled_response
    end

    def post(uri, params = {})
      ret = single_request(uri, :post, body: params)
      ret.handled_response
    end

    def put(uri, params = {})
      ret = single_request(uri, :put, body: params)
      ret.handled_response
    end

    def delete(uri)
      ret = single_request(uri, :delete)
      ret.handled_response
    end

    private

    attr_reader :logger

    # TyphoeusでAPIリクエストを行う
    #
    # @param [String] uri
    # @param [Symbol] method
    # @param [Hash] options
    # @option options [Hash] :params リクエストパラメータ
    # @option options [Hash] :body リクエストボディ
    # @option options [Hash] :headers リクエストヘッダー
    #
    # @return [Typhoeus::Response]
    def single_request(uri, method, options = {})
      opt = { method: method, followlocation: true }
      req = Typhoeus::Request.new(uri, opt.merge(options))
      tried = 0

      req.on_complete do |res|
        if res.success?
          parsed_data = JSON.parse(res.response_body, object_class: OpenStruct)
          { body: parsed_data, status: res.code }
        # elsif res.timed_out?
        #   logger.error('request timedout.')
        elsif res.code.zero?
          logger.error(res.return_message)
          res
        else
          logger.error('HTTP request failed. error_code: ' + res.code.to_s)
          if tried < retry_intervals.length
            sleep retry_intervals[tried]
            tried += 1
            req.run
          else
            res
          end
        end
      end

      req.run
    end
  end
end
