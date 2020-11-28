# デプロイ上必要となる情報を扱う
#
# ## index
#
# デプロイ時のソースコードバージョンを明確にするために
# 以下の情報を http header として返す
#
# - X-App-Sha1-Version
#     - ビルド時のコミットハッシュ
# - X-App-Deploy-Time
#     - ビルド日時
#
# ## health_check
#
# ELB の health check 用
#
# ## databse_check
#
# CircleCI でDB接続を試す用
#
# ## benchmark_check
#
# 相対負荷テスト用
#
class InformationsController < ApplicationController
  # バージョンとdeploy日時を返す
  def index
    response.headers['X-App-Sha1-Version'] = Settings.version_id
    response.headers['X-App-Deploy-Time'] = Settings.deploy_datetime
    response.headers['X-App-Rails-Env'] = Rails.env
    head :ok
  end

  def health_check
    head :ok
  end

  def database_check
    if ApplicationRecord.methods.include?(:operation_check)
      ApplicationRecord.operation_check
    else
      DbConnection.all
    end

    head :no_content
  end

  def benchmark_check
    result =
      if ApplicationRecord.methods.include?(:database_stress)
        ApplicationRecord.database_stress
      else
        DbConnection.select(:id, :name, :adapter, :created_at, :updated_at)
      end

    render json: result
  end
end
