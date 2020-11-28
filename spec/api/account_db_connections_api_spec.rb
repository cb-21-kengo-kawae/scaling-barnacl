RSpec.describe Api::AccountDbConnectionsApi, type: :request do
  let(:data_view_id) { 1 }
  let(:account_id) { 1 }
  let(:user_id) { 1 }
  let(:params) { {} }
  let(:default_db_config) { Rails.application.config.database_configuration[Rails.env] }
  let(:db_connection) { build(:account_db_connection) }

  describe 'GET /api/account_db_connections/:id' do
    subject { get '/api/account_db_connections/1' }

    before do
      allow(DbConnection::AccountDbConnection).to(
        receive_message_chain('where.not.select.find_by').and_return(db_connection)
      )
    end

    it do
      expect(DbConnection::AccountDbConnection).to(
        receive_message_chain('where.not.select.find_by')
      )
      subject
      expect(response.body).to eq(db_connection.attributes.to_json)
    end
  end

  describe 'POST /api/account_db_connections/' do
    subject { post '/api/account_db_connections/', params: params }

    let(:host) { Rails.configuration.database_configuration[Rails.env]['host'] }
    let(:provisioning_double) { instance_double 'Accounts::ProvisioningService' }

    before do
      allow(Accounts::ProvisioningService).to receive(:new).and_return(provisioning_double)
      allow(provisioning_double).to receive(:provision!)
    end

    let(:provision_params) do
      params_dup = params.slice(
        :account_id, :data_view_id, :user_id, :host, :data_host, :port, :data_port
      )
      params_dup[:port] = nil if params_dup[:port].blank?
      params_dup[:data_port] = nil if params_dup[:data_port].blank?
      params_dup
    end

    shared_examples 'params.are.valid' do
      it 'アカウント単位DBが準備されること' do
        expect(Accounts::ProvisioningService).to(
          receive(:new).with(provision_params)
        )
        expect(provisioning_double).to receive(:provision!)
        subject
        expect(response.body).to eq({ result: 0 }.to_json)
      end
    end

    shared_examples 'params.are.invalid' do
      it '400 か 404 を返しアカウントDBに関する処理を行わないこと' do
        expect(Accounts::ProvisioningService).not_to receive(:new)
        expect(provisioning_double).not_to receive(:provision!)
        subject
        expect([400, 404].member?(response.status)).to eq(true)
      end
    end

    context '適切なパラメーターが渡されたら' do
      let(:params) do
        {
          account_id: account_id,
          data_view_id: data_view_id,
          user_id: user_id,
          host: default_db_config['host'],
          data_host: default_db_config['host']
        }
      end

      include_examples 'params.are.valid'

      context 'port が指定されても' do
        let(:params) do
          {
            account_id: account_id,
            data_view_id: data_view_id,
            user_id: user_id,
            host: default_db_config['host'],
            data_host: default_db_config['host'],
            port: default_db_config['port']
          }
        end

        include_examples 'params.are.valid'
      end
    end

    context 'account_id が' do
      context '指定されない場合' do
        let(:params) do
          {
            data_view_id: data_view_id,
            user_id: user_id,
            host: default_db_config['host'],
            data_host: default_db_config['host'],
            port: default_db_config['port']
          }
        end

        include_examples 'params.are.invalid'
      end

      context '文字列の場合' do
        let(:params) do
          {
            account_id: 'account_id',
            data_view_id: data_view_id,
            user_id: user_id,
            host: default_db_config['host'],
            data_host: default_db_config['host'],
            port: default_db_config['port']
          }
        end

        include_examples 'params.are.invalid'
      end
    end

    context 'data_view_id が' do
      context '指定されない場合' do
        let(:params) do
          {
            account_id: account_id,
            user_id: user_id,
            host: default_db_config['host'],
            data_host: default_db_config['host'],
            port: default_db_config['port']
          }
        end

        include_examples 'params.are.invalid'
      end

      context '文字列の場合' do
        let(:params) do
          {
            account_id: account_id,
            data_view_id: 'data_view_id',
            user_id: user_id,
            host: default_db_config['host'],
            data_host: default_db_config['host'],
            port: default_db_config['port']
          }
        end

        include_examples 'params.are.invalid'
      end
    end

    context 'user_id が' do
      context '指定されない場合' do
        let(:params) do
          {
            account_id: account_id,
            data_view_id: data_view_id,
            host: default_db_config['host'],
            data_host: default_db_config['host'],
            port: default_db_config['port']
          }
        end

        include_examples 'params.are.invalid'
      end

      context '文字列の場合' do
        let(:params) do
          {
            account_id: account_id,
            data_view_id: data_view_id,
            user_id: 'user_id',
            host: default_db_config['host'],
            data_host: default_db_config['host'],
            port: default_db_config['port']
          }
        end

        include_examples 'params.are.invalid'
      end
    end

    context 'host が指定されない場合' do
      let(:params) do
        {
          account_id: account_id,
          data_view_id: data_view_id,
          user_id: user_id,
          data_host: default_db_config['host'],
          port: default_db_config['port']
        }
      end

      include_examples 'params.are.invalid'
    end

    context 'data_host が指定されない場合' do
      let(:params) do
        {
          account_id: account_id,
          data_view_id: data_view_id,
          user_id: user_id,
          host: default_db_config['host'],
          port: default_db_config['port']
        }
      end

      include_examples 'params.are.invalid'
    end
  end
end
