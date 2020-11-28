module Admin
  module AccountDbConnections
    module Controllers
      # AccountDbConnective を扱うためのヘルパー
      module Helpers
        extend ActiveSupport::Concern

        private

        def connect_account_db
          AccountRecord.connect(account_id: account_id)
        end

        def disconnect_account_db
          AccountRecord.disconnect
        end
      end
    end
  end
end
