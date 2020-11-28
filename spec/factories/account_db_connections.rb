FactoryBot.define do
  factory :account_db_connection, class: 'DbConnection::AccountDbConnection' do
    host { 'localhost' }
    port { 123 }
    type { 'DbConnection::AccountDbConnection' }
  end
end
