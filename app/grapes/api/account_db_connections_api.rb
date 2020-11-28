module Api
  # DbConnections
  class AccountDbConnectionsApi < Grape::API
    include ErrorHandling

    desc 'アカウント単位DBの接続情報を扱う'
    resource :account_db_connections do
      desc 'アカウント単位DBの接続情報を取得します'
      get '/:id' do
        conn = DbConnection::AccountDbConnection.where.not(db_created_at: nil).select(
          :id, :host, :port, :pool, :adapter, :database, :db_created_at
        ).find_by(account_id: params[:id])
        conn_info = conn ? conn.attributes : {}
        conn_info
      end

      desc 'アカウント単位DBの接続情報を作成します'
      params do
        requires :account_id, type: Integer
        requires :data_view_id, type: Integer
        requires :user_id, type: Integer
        requires :host, type: String, desc: 'Host'
        requires :data_host, type: String, desc: 'DataDbHost'
        optional :port, type: Integer, desc: 'Port'
        optional :data_port, type: Integer, desc: 'DataDbPort'
      end
      post '/' do
        allowed_params = declared(params)

        Accounts::ProvisioningService.new(
          allowed_params
        ).provision!

        { result: 0 }
      end
    end
  end
end
