class DbConnection
  # アカウント単位データベースの接続情報を扱う
  class AccountDbConnection < DbConnection
    include Fs::Multidb::Models::DbConnective::AccountDbConnective

    validates :account_id, uniqueness: true

    private

    def defaults
      self.port ||= application_db_config['port'] || 3306
      self.pool ||= application_db_config['pool'] || 5
      self.adapter ||= application_db_config['adapter'] || 'mysql2'
      self.database ||= default_database
      self
    end

    def username
      application_db_config['username']
    end

    def password
      application_db_config['password']
    end
  end
end
