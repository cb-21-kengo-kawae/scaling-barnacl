shared_context 'account_record.helper' do
  shared_context 'let.db_connection' do |args = {}|
    let(:account_id) { args[:account_id] || 1 }

    let(:db_connection) do
      db_config = Rails.application.config.database_configuration[Rails.env]

      DbConnection::AccountDbConnection.find_or_create_by!(
        account_id: account_id,
        host: db_config['host'],
        db_created_at: Time.current
      )
    end
  end

  shared_context 'allow.account.db' do |_args = {}|
    before do
      allow(AccountRecord).to receive(:connect)
      allow(AccountRecord).to receive(:disconnect)
    end
  end
end

shared_context 'account_record.helper.all' do
  include_context 'account_record.helper'
  include_context 'let.db_connection'
  include_context 'allow.account.db'
end
