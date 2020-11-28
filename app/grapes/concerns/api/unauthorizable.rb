module Api
  # Unauthorized API default module
  module Unauthorizable
    extend ActiveSupport::Concern
    include ConnectedAccountRecord
    include ErrorHandling

    included do
      before do
        connect_account_db(current_account_id)
      end

      helpers do
        # リクエストパラメタのアカウントIDを返す
        #
        # @return [Integer] account_id
        def current_account_id
          params[:account_id]
        end

        # リクエストパラメタのDataViewIDを返す
        #
        # @return [Integer] data_view_id
        def current_view_id
          params[:data_view_id]
        end

        # ロガーを提供します
        # @return [ActiveSupport::Logger] logger
        def logger
          Fs::Zeldalogging.logger
        end
      end
    end
  end
end
