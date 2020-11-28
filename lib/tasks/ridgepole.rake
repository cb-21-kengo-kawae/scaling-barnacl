namespace :ridgepole do
  task :arguments do |_cmd, args|
    @args = args
  end

  task :ridgepole_client do
    config = Rails.application.config.database_configuration[Rails.env]
    @ridgepole_client = Ridgepole::Client.new(config, dump_with_default_fk_name: true)
  end

  desc 'ridgepole --export を実行します。 [出力ファイル]'
  task :export, [:path] => %i[environment arguments ridgepole_client] do
    path = @args.path || Rails.root.join('db', 'Schemafile')

    File.binwrite path, @ridgepole_client.dump + "\n"
  end

  desc 'ridgepole --apply を実行します。 [Schemafileパス]'
  task :apply, [:path] => %i[environment arguments ridgepole_client] do
    path = @args.path || Rails.root.join('db', 'Schemafile')
    schema = File.read(path)

    delta = @ridgepole_client.diff(schema, path: path.to_s)

    differ, = delta.migrate

    puts 'No change' unless differ
  end

  desc '共通DB及びアカウント単位DBを全て更新する'
  task(
    :apply_all,
    [] => [:environment, :arguments, :apply, 'account_record:ridgepole:apply_all']
  )
end
