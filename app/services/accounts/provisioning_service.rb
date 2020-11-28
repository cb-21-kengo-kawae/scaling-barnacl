module Accounts
  # アカウントのデータベースをセットアップするサービス
  #
  # - アカウント単位DBを作成する
  # - アカウント単位DBに初期データを投入する
  class ProvisioningService
    # @param params [Hash]
    # @option params [Integer] :account_id アカウントID
    # @option params [Integer] :data_view_id データビューID
    # @option params [String] :hosr ホストURL
    # @option params [Integer, String] :port ポート番号
    # @option params [String] :data_host データDBのホストURL
    # @option params [Integer, String] :port データDBのポート番号
    def initialize(params)
      @account_id   = params[:account_id]
      @data_view_id = params[:data_view_id]
      @host         = params[:host]
      @port         = params[:port].presence || nil
      @data_host    = params[:data_host]
      @data_port    = params[:port].presence || nil
      @do_rollback  = false
    end

    # アカウント別DBのプロビジョニング処理
    #
    # @raise [RuntimeError] アカウント別DBの作成失敗時
    def provision!
      ActiveRecord::Base.transaction do
        db_manager.create!
      end
      db_manager.migrate!

      AccountRecord.connect(account_id: @account_id) do
        AccountRecord.transaction do
          role_policies_manager.provision!
        end
      end
    rescue StandardError => e
      Fs::Zeldalogging.logger.warn e
      if @do_rollback == true
        # 実行とは逆順に処理する
        db_manager.drop!

        # db_connection情報を削除
        DbConnection.where(account_id: @account_id).destroy_all
      end

      # Admin側でエラーにするための再raise
      raise "Failed to provision preparation service.[account: #{@account_id}]"
    end

    private

    # @return [String]
    def default_db_config
      @default_db_config ||= Rails.configuration.database_configuration[Rails.env]
    end

    # @return [AccountRecords::ProvisioningService::DatabaseManager]
    def db_manager
      @db_manager ||=
        AccountRecords::ProvisioningService::DatabaseManager.new(db_connection)
    end

    # @return [RolePolicies::ProvisioningService]
    def role_policies_manager
      @role_policies_manager ||= RolePolicies::ProvisioningService.new(db_connection)
    end

    # `fs-resourcekeeper` に必要なテーブルを管理する。
    #
    # @return [Fs::Resourcekeeper::Services::ProvisionService]
    def resourcekeeper_manager
      @resourcekeeper_manager ||= Fs::Resourcekeeper::Services::ProvisionService.new(@account_id)
    end

    # @return [Hash]
    def connection_params
      {
        account_id: @account_id,
        host: @host,
        port: @port || default_db_config['port']
      }
    end

    # @return [DbConnection::AccountDbConnection]
    def db_connection
      @db_connection ||=
        DbConnection::AccountDbConnection.find_or_create_by!(connection_params) do
          @do_rollback = true
        end
    end
  end
end
