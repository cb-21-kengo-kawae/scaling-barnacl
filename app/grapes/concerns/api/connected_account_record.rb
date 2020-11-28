module Api
  # アカウントDBに接続ヘルパーを提供
  module ConnectedAccountRecord
    extend ActiveSupport::Concern
    include ErrorHandling

    included do
      helpers do
        # アカウントDBに接続
        #
        # @param [Integer] account_id アカウントID
        def connect_account_db(account_id)
          AccountRecord.connect(account_id: account_id)
        end
      end
    end
  end
end
