RSpec.describe Accounts::ProvisioningService do
  include_context 'account_record.helper'
  include_context 'let.db_connection'

  let(:account_id) { 1 }
  let(:data_view_id) { 1 }
  let(:user_id) { 1 }

  let(:host) { Rails.configuration.database_configuration[Rails.env]['host'] }
  let(:port) { Rails.configuration.database_configuration[Rails.env]['port'] }

  let(:provisioning) do
    Accounts::ProvisioningService.new(
      account_id: account_id,
      data_view_id: data_view_id,
      user_id: user_id,
      host: host
    )
  end

  describe '#provision!' do
    let(:db_manager_double) { double('db_manager') }
    let(:role_policies_manager_double) { double('role_policies_manager') }

    before do
      allow(AccountRecords::ProvisioningService::DatabaseManager).to receive(:new).and_return(db_manager_double)
      allow(db_manager_double).to receive(:migrate!).and_return(true)
      allow(AccountRecord).to receive(:connect).and_yield
      allow(AccountRecord).to receive(:transaction).and_yield
      allow(provisioning).to receive(:role_policies_manager).and_return(role_policies_manager_double)
      allow(role_policies_manager_double).to receive(:provision!).and_return(true)
    end
    subject { provisioning.provision! }

    context 'normal system' do
      before do
        allow(db_manager_double).to receive(:create!).and_return(true)
      end
      it do
        expect(db_manager_double).to receive(:create!)
        expect(db_manager_double).to receive(:migrate!)
        expect(AccountRecord).to receive(:connect)
        expect(AccountRecord).to receive(:transaction)
        expect(role_policies_manager_double).to receive(:provision!)
        subject
      end
    end

    context 'Abnormal system' do
      before do
        allow(db_manager_double).to receive(:create!).and_raise(RuntimeError)
        allow(db_manager_double).to receive(:drop!)
        allow(DbConnection).to receive_message_chain(:where, :destroy_all)
      end
      subject { -> { provisioning.provision! } }

      context 'do rollback' do
        before do
          allow(DbConnection::AccountDbConnection).to receive(:find_or_create_by!).and_yield
        end
        it do
          expect(db_manager_double).to receive(:create!)
          expect(db_manager_double).to receive(:drop!)
          expect(DbConnection).to receive_message_chain(:where, :destroy_all)
          is_expected.to raise_error(RuntimeError)
        end
      end

      context 'do not rollback' do
        before do
          allow(DbConnection::AccountDbConnection).to receive(:find_or_create_by!)
        end
        it do
          expect(db_manager_double).to receive(:create!)
          expect(db_manager_double).not_to receive(:drop!)
          is_expected.to raise_error(RuntimeError)
        end
      end
    end
  end

  describe '#db_manager' do
    subject { provisioning.send :db_manager }

    let(:manager_double) do
      instance_double 'AccountRecords::ProvisioningService::DatabaseManager'
    end

    before do
      allow(provisioning).to receive(:db_connection).and_return(db_connection)
      allow(AccountRecords::ProvisioningService::DatabaseManager).to(
        receive(:new).and_return(manager_double)
      )
    end

    it do
      expect(AccountRecords::ProvisioningService::DatabaseManager).to(
        receive(:new)
      )
      is_expected.to eq(manager_double)
    end
  end

  describe '#role_policies_manager' do
    subject { provisioning.send :role_policies_manager }

    let(:manager_double) do
      instance_double 'RolePolicies::ProvisioningService'
    end

    before do
      allow(provisioning).to receive(:db_connection).and_return(db_connection)
      allow(RolePolicies::ProvisioningService).to(
        receive(:new).and_return(manager_double)
      )
    end

    it do
      expect(RolePolicies::ProvisioningService).to(
        receive(:new)
      )
      is_expected.to eq(manager_double)
    end
  end

  describe '#db_connection' do
    subject { provisioning.send :db_connection }

    it do
      is_expected.to be_a(DbConnection::AccountDbConnection)
      expect(subject.account_id).to eq(account_id)
      expect(subject.host).to eq(host)
      expect(subject.port).to eq(port)
    end
  end
end
