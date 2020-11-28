module TyphoeusApiGateway
  # APIアクセスを提供する
  class BaseGateway
    def initialize(params)
      @account_id = params.fetch(:account_id, nil)
      @user_id    = params.fetch(:user_id, nil)
    end

    def index
      raise NotImplementedError, 'require #index'
    end

    def show
      raise NotImplementedError, 'require #show'
    end

    def create
      raise NotImplementedError, 'require #create'
    end

    def update
      raise NotImplementedError, 'require #update'
    end

    def destroy
      raise NotImplementedError, 'require #destroy'
    end

    private

    attr_reader :account_id, :user_id

    def client
      @client ||= TyphoeusApiClient.new
    end

    def relative_url_root
      raise NotImplementedError, 'require #relative_url_root'
    end

    def relative_path
      raise NotImplementedError, 'require #relative_path'
    end

    def private_api_root_path
      @private_api_root_path ||= "#{Settings.private_url}#{relative_url_root}"
    end

    def base_uri
      @base_uri ||= [private_api_root_path, 'api', relative_path].join('/')
    end
  end
end
