namespace :account_record do
  task :arguments do |_cmd, args|
    @args = args
  end

  desc 'アカウントのDBを準備します'
  task :provision, %i[account_id data_view_id user_id host data_host] => %i[environment arguments] do
    default_host = Rails.configuration.database_configuration[Rails.env]['host']
    Accounts::ProvisioningService.new(
      account_id: @args.account_id,
      data_view_id: @args.data_view_id,
      user_id: @args.user_id,
      host: @args.host || default_host,
      data_host: @args.data_host || default_host
    ).provision!
  end
end
