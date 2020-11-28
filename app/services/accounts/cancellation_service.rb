module Accounts
  # アカウントのデータベースを削除するサービス
  class CancellationService
    # @param account_id [Integer]
    def initialize(account_id)
      @account_id = account_id
    end

    # アカウント別DBの削除
    def drop!
      db_manager.drop!
      # db_connection情報を削除
      DbConnection.where(account_id: @account_id).destroy_all
    end

    private

    # @return [AccountRecords::ProvisioningService::DatabaseManager]
    def db_manager
      @db_manager ||=
        AccountRecords::ProvisioningService::DatabaseManager.new(db_connection)
    end

    # @return [Hash]
    def connection_params
      {
        account_id: @account_id
      }
    end

    # @return [DbConnection::AccountDbConnection]
    def db_connection
      @db_connection ||= DbConnection::AccountDbConnection.find_by(connection_params)
    end
  end
end
