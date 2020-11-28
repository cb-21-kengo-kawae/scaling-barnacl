namespace :account_record do
  task :arguments do |_cmd, args|
    @args = args
  end

  namespace :ridgepole do
    desc 'アカウント単位DBに対して ridgepole --export を実行します。option [アカウントID]'
    task :export, [:account_id] => %i[environment arguments] do
      account_id = @args.account_id || DbConnection::AccountDbConnection.select(:id).first.id
      path = Rails.root.join('db', 'multi_db', 'account_record', 'Schemafile')

      db_connection = DbConnection::AccountDbConnection.find_by!(account_id: account_id)

      ridgepole_client =
        RidgepoleUtil.client(db_connection.config, dump_with_default_fk_name: true)

      File.binwrite path, ridgepole_client.dump + "\n"
    end

    desc(
      'アカウント単位DBに対して ridgepole --apply を実行します。'\
      'option [アカウントID] 指定しない場合全てのアカウントが対象になります。'
    )
    task :apply, [:account_id] => %i[environment arguments] do
      account_id = @args.account_id

      path = Rails.root.join('db', 'multi_db', 'account_record', 'Schemafile')
      schema = File.read(path)

      db_connection = DbConnection::AccountDbConnection.find_by!(account_id: account_id)

      connection_config = db_connection.config

      unless AccountRecord.database_exists?(connection_config)
        puts 'Database not found.'
        next
      end

      puts "\n----- ridgepole apply account_id: #{account_id} start -----"

      ridgepole_client =
        RidgepoleUtil.client(connection_config, dump_with_default_fk_name: true)

      delta = ridgepole_client.diff(schema, path: path.to_s)

      differ, = delta.migrate

      puts 'No change' unless differ

      puts "----- ridgepole apply account_id: #{account_id} end -----\n"
    end

    desc '接続情報がある全てのアカウントのスキーマを更新する'
    task :apply_all, [:account_id] => %i[environment arguments] do
      path = Rails.root.join('db', 'multi_db', 'account_record', 'Schemafile')
      schema = File.read(path)

      puts "\n----- account db apply start -----"

      all_connection = AccountRecord.send(:all_db_connections).select do |conn|
        AccountRecord.send(:database_exists?, conn.config)
      end

      Parallel.map(all_connection, in_processes: Parallel.processor_count) do |connection|
        puts "\n    account: #{connection.account_id} start\n\n"

        ridgepole_client =
          RidgepoleUtil.client(connection.config, dump_with_default_fk_name: true)

        delta = ridgepole_client.diff(schema, path: path.to_s)

        differ, = delta.migrate

        puts 'No change' unless differ

        puts "\n    account: #{connection.account_id} end\n\n"
      end

      puts "\n----- account db apply end -----"
    end
  end
end
