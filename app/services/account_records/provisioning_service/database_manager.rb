module AccountRecords
  module ProvisioningService
    # Manage Account Unit DB
    class DatabaseManager
      SCHEMA_PATH = Rails.root.join('db', 'multi_db', AccountRecord.name.underscore, 'Schemafile')

      # @param db_connection [DbConnection::AccountDbConnection]
      def initialize(db_connection)
        @db_connection = db_connection
        @config = @db_connection.config
      end

      # @return [boolean]
      def exists?
        AccountRecord.database_exists? @config
      end

      # @return [Boolean, null] TRUE IF CREATE DATABASE SUCCESSFUL, Null IF DATABASE EXISTS.
      def create!
        if exists?
          return if @db_connection.db_created_at

          @db_connection.update! db_created_at: Time.current

          return
        end

        AccountRecord.temporary_connect_without_database(@config) do
          AccountRecord.connection.execute(
            "CREATE DATABASE \`#{@config[:database]}\` DEFAULT CHARACTER SET utf8;"
          )
        end

        @db_connection.update! db_created_at: Time.current

        true
      end

      # @return [Boolean, null] TRUE IF DROP DATABASE SUCCESSFUL, NULL IF DATABASE NOT EXISTS.
      def drop!
        unless exists?
          return unless @db_connection.db_created_at

          @db_connection.update! db_created_at: nil

          return
        end

        AccountRecord.temporary_connect_without_database(@config) do
          AccountRecord.connection.execute(
            "DROP DATABASE \`#{@config[:database]}\`;"
          )
        end

        @db_connection.update! db_created_at: nil

        true
      end

      # @return [Boolean]
      def migrate!
        db_schema = File.read(SCHEMA_PATH)

        before_connection = ActiveRecord::Base.connection_config

        begin
          RidgepoleUtil
            .client(@config, dump_with_default_fk_name: true)
            .diff(db_schema, path: SCHEMA_PATH.to_s)
            .migrate
        ensure
          ActiveRecord::Base.establish_connection before_connection
        end

        true
      end
    end
  end
end
