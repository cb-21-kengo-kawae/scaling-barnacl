# アカウント単位DBを扱う
class AccountRecord < ActiveRecord::Base
  include Fs::Multidb::Models::MultiDb::MultiAccountDb

  self.abstract_class = true

  class << self
    private

    def db_connection_class
      DbConnection::AccountDbConnection
    end
  end
end
