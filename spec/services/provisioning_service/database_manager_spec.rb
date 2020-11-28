RSpec.describe AccountRecords::ProvisioningService::DatabaseManager do
  include_context 'account_record.helper'
  include_context 'let.db_connection'

  let(:manager) { described_class.new db_connection }

  describe '#exists?' do
    subject { manager.exists? }

    context 'when the database exists' do
      before do
        allow(AccountRecord).to receive(:database_exists?).and_return(true)
      end

      it do
        is_expected.to eq(true)
      end
    end

    context 'when the database does not exists' do
      before do
        allow(AccountRecord).to receive(:database_exists?).and_return(false)
      end

      it do
        is_expected.to eq(false)
      end
    end
  end

  describe '#create!' do
    subject { manager.create! }

    before do
      allow(AccountRecord).to receive(:temporary_connect_without_database)
      allow(AccountRecord).to receive_message_chain('connection.execute')
      allow(db_connection).to receive(:update!)
    end

    context 'table exists' do
      before do
        allow(manager).to receive(:exists?).and_return(true)
      end

      context 'DbConnection::AccountDbConnection#db_created_at is set' do
        before do
          allow(db_connection).to receive(:db_created_at).and_return(true)
        end

        it do
          is_expected.to eq(nil)
        end
      end

      context 'DbConnection::AccountDbConnection#db_created_at isnt set' do
        before do
          allow(db_connection).to receive(:db_created_at).and_return(false)
        end

        it do
          expect(db_connection).to receive(:update!).with(db_created_at: Time)
          is_expected.to eq(nil)
        end
      end
    end

    context 'table does not exists' do
      before do
        allow(manager).to receive(:exists?).and_return(false)
      end

      it do
        expect(AccountRecord).to receive(:temporary_connect_without_database).and_yield
        expect(AccountRecord).to receive_message_chain('connection.execute')
        expect(db_connection).to receive(:update!).with(db_created_at: Time)
        is_expected.to eq(true)
      end
    end
  end

  describe '#drop!' do
    subject { manager.drop! }

    context 'table does not exist' do
      before do
        allow(manager).to receive(:exists?).and_return(false)
        allow(db_connection).to receive(:update!)
      end

      context 'DbConnection::AccountDbConnection#db_created_at is set' do
        before do
          allow(db_connection).to receive(:db_created_at).and_return(nil)
        end

        it do
          is_expected.to eq(nil)
        end
      end

      context 'DbConnection::AccountDbConnection#db_created_at isnt set' do
        before do
          allow(db_connection).to receive(:db_created_at).and_return(true)
        end

        it do
          expect(db_connection).to receive(:update!).with(db_created_at: nil)
          is_expected.to eq(nil)
        end
      end
    end

    context do
      before do
        allow(manager).to receive(:exists?).and_return(true)
      end

      it do
        expect(AccountRecord).to receive(:temporary_connect_without_database).and_yield
        expect(AccountRecord).to receive_message_chain('connection.execute')
        expect(db_connection).to receive(:update!).with(db_created_at: nil)
        is_expected.to eq(true)
      end
    end
  end

  describe '#migrate!' do
    subject { manager.migrate! }

    let(:connection) { double }

    it do
      expect(ActiveRecord::Base).to receive(:connection_config).and_return(connection)
      expect(RidgepoleUtil).to receive_message_chain('client.diff.migrate')
      expect(ActiveRecord::Base).to receive(:establish_connection)
      is_expected.to eq(true)
    end
  end
end
