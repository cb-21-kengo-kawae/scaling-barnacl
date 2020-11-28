module Accounts
  # アカウントのデータベースをセットアップするサービス
  #
  # ## 仕様
  #
  # - アカウント単位DBを作成する
  # - アカウント単位DBに初期データを投入する
  # - 外部データ用DBを作成する
  # - 外部データ用DBにデフォルトテーブルを作成する
  # - セグメントフォームプリセットデータを作成する
  # - 広告ベンダーのデータを作成する
  # - トラッキングスクリプトを作成する
  #
  # ## Rake タスク
  #
  # 以下の Rake タスクでアカウントに必要なDB及びデータを作成できる
  #
  # ```
  # # 引数: [account_id,data_view_id,user_id]
  # bundle exec rake account_record:provision[1,1,1]
  # ```
  #
  # :reek:TooManyMethods
  class ProvisioningService
    # @param options [Hash]
    # @option options [Integer] :account_id アカウントID
    # @option options [Integer] :data_view_id データビューID
    # @option options [Integer] :user_id ユーザID
    # @option options [String] :host アカウント別DBのホスト
    # @option options [Integer] :port アカウント別DBのポート
    # @option options [String] :data_host アカウント別データDBのホスト
    # @option options [Integer] :data_port アカウント別データDBのポート
    def initialize(options)
      @account_id = options[:account_id]
      @data_view_id = options[:data_view_id]
      @user_id = options[:user_id]
      @host = options[:host]
      @port = options[:port]
      @data_host = options[:data_host]
      @data_port = options[:data_port]
    end

    # @return [true]
    def provision!
      # データの接続先ホストが存在するかのチェックも兼ねる。
      # これによってホストが存在しない時にdb_connectionsテーブルに接続情報が残るのを避ける
      ActiveRecord::Base.transaction do
        db_manager.create!
      end

      db_manager.migrate!
      db_sower.seed!

      data_db_manager.create!

      resourcekeeper_provision.provision!

      data_view_manager.provision!
      role_manager.provision!

      segment_form_preset_manager.provision!

      ad_vendor_manager.provision!

      # tracking_script_manager.provision! unless Rails.env.development?

      true
    rescue => ex
      raise
      Fs::Zeldalogging.logger.warn ex
      db_manager.drop!
      data_db_manager.drop!
      resourcekeeper_provision.drop!
      # db_connection情報を削除
      DbConnection.where(account_id: @account_id).destroy_all
      # Admin側でエラーにするための再raise
      # raise "Could not platform provisioning.[account: #{@account_id}]"
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

    # @return [AccountRecords::ProvisioningService::Sower]
    def db_sower
      @db_sower ||= AccountRecords::ProvisioningService::Sower.new(@account_id)
    end

    # @return [AccountDataRecords::ProvisioningService::DatabaseManager]
    def data_db_manager
      @data_db_manager ||=
        AccountDataRecords::ProvisioningService::DatabaseManager.new(data_db_connection)
    end

    # @return [DataViews::ProvisioningService]
    def data_view_manager
      @data_view_manager ||= DataViews::ProvisioningService.new(
        account_id: @account_id,
        data_view_id: @data_view_id,
        user_id: @user_id
      )
    end

    # @return [Roles::ProvisioningService]
    def role_manager
      @role_manager ||= Roles::ProvisioningService.new(
        user_id: @user_id,
        account_id: @account_id
      )
    end

    # @return [SegmentFormPresets::ProvisioningService]
    def segment_form_preset_manager
      @segment_form_preset_manager ||= SegmentFormPresets::ProvisioningService.new(
        user_id: @user_id,
        account_id: @account_id
      )
    end

    # @return [AdVendors::ProvisioningService]
    def ad_vendor_manager
      @ad_vendor_manager ||= AdVendors::ProvisioningService.new(
        user_id: @user_id,
        account_id: @account_id
      )
    end

    # @return [BdashTag::ProvisioningService]
    def tracking_script_manager
      @tracking_script_manager ||= BdashTag::ProvisioningService.new(account_id: @account_id)
    end

    # @return [Fs::Resourcekeeper::Services::ProvisionService]
    def resourcekeeper_provision
      @resourcekeeper_provision ||= Fs::Resourcekeeper::Services::ProvisionService.new(@account_id)
    end

    # @return [Hash]
    def connection_params
      {
        account_id: @account_id,
        host: @host,
        port: @port || default_db_config['port']
      }
    end

    # @return [Hash]
    def data_db_connection_params
      {
        account_id: @account_id,
        host: @data_host,
        port: @data_port || default_db_config['port']
      }
    end

    # @return [DbConnection::AccountDbConnection]
    def db_connection
      @db_connection ||=
        DbConnection::AccountDbConnection.find_or_create_by!(connection_params)
    end

    # @return [DbConnection::AccountDataDbConnection]
    def data_db_connection
      @data_db_connection ||=
        DbConnection::AccountDataDbConnection.find_or_create_by!(data_db_connection_params)
    end
  end
end
