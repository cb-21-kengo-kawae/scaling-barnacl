RSpec.describe Accounts::CancellationService do
  include_context 'account_record.helper'
  include_context 'let.db_connection'

  let(:account_id) { 1 }
  let(:service) do
    described_class.new(account_id)
  end

  describe '.drop!' do
    let(:db_manager) { instance_double(AccountRecords::ProvisioningService::DatabaseManager) }
    before do
      allow(AccountRecords::ProvisioningService::DatabaseManager).to receive(:new).and_return(db_manager)
      allow(db_manager).to receive(:drop!)
      allow(DbConnection::AccountDbConnection).to receive(:find_by)
      allow(DbConnection).to receive_message_chain(:where, :destroy_all)
    end

    subject { service.drop! }
    it do
      expect(db_manager).to receive(:drop!)
      expect(DbConnection).to receive_message_chain(:where, :destroy_all)
      subject
    end
  end
end
