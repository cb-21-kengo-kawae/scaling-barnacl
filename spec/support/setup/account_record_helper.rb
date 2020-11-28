if ENV['TEST_ENV_NUMBER']
  # parallel_tests用の拡張 (アカウントDBを並列するテストのプロセス毎に分ける対応)
  module AccountDbConnectionExtension
    private

    def default_database
      [default_database_basename, account_id.to_s.rjust(4, '0'), ENV['TEST_ENV_NUMBER']].join('_')
    end
  end
  DbConnection::AccountDbConnection.prepend(AccountDbConnectionExtension)
end

dir = Rails.root.join('tmp', 'account_record')
path = dir.join('schema_hash.txt')

FileUtils.mkdir_p(dir) unless File.directory?(dir)
FileUtils.touch path

account_record_schema_path = Rails.root.join('db', 'multi_db', 'account_record', 'Schemafile')
account_record_schema = File.read(account_record_schema_path)

file_hash = Digest::MD5.hexdigest(account_record_schema)

cache_hash = File.read(path)

account_id = 1

RSpec.configure do |config|
  config.before :suite do
    changed = file_hash != cache_hash

    db_config = Rails.application.config.database_configuration[Rails.env]

    db_connection = DbConnection::AccountDbConnection.find_or_create_by!(
      account_id: account_id,
      host: db_config['host']
    )

    connection_config = db_connection.config

    db_manager = AccountRecords::ProvisioningService::DatabaseManager.new(db_connection)

    if changed || !AccountRecord.database_exists?(connection_config)
      db_manager.drop!
      db_manager.create!
      db_manager.migrate!

      File.write path, file_hash
    else
      db_connection.update! db_created_at: Time.current
    end

    # foreign keyの依存も含めて消してくれる + DatabaseRewinder.cleanの対象にするために、DatabaseRewinderを使う
    DatabaseRewinder.database_configuration['account_record'] = connection_config.with_indifferent_access

    # 一度呼び出さないと cleaners に登録されない
    DatabaseRewinder['account_record']

    AccountRecord.connect account_id: account_id
  end

  config.after :all do
    default_database = "test_template4th_#{account_id.to_s.rjust(4, '0')}"
    default_database << "_#{ENV['TEST_ENV_NUMBER']}" if ENV['TEST_ENV_NUMBER']

    if AccountRecord.connection_config[:database] != default_database
      raise(
        'AccountRecord は常に接続状態になるようになっています。'\
        'どうしても disconnect したい場合は after で接続しなおしてください。'
      )
    end
  end

  config.after :suite do
    AccountRecord.clear_all_connections!
  end
end
