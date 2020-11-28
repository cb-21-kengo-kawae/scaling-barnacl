module RolePolicies
  # アカウント作成時の初期権限セットを準備する
  class ProvisioningService
    # 各デファルトロールに対するseedファイルのパス
    ROLE_POLICIES_SEED_DIR = Rails.root.join('db', 'multi_db', 'account_record', 'seeds')
    DEFAULT_ROLE_TYPE = %i[admin marketer agency creator].freeze
    LOOKUP_POLICY_LEVEL = { nothing: 1, read_only: 2, edit: 3 }.freeze

    # initialize
    # @param db_connection [DbConnection::AccountDbConnectio]
    def initialize(db_connection)
      @db_connection = db_connection
      @policy_list = Policy.all
    end

    # @return [Boolean]
    def provision!
      # platformからロール一覧を取得
      roles = TyphoeusApiGateway::Platform::RoleGateway.new(account_id: @db_connection.account_id).index
      roles.each do |role|
        if role.is_admin == true || role.default_role_type == 'admin'
          # 管理者ロールに対しての設定
          provision_admin_role_policies(role.id)
        elsif DEFAULT_ROLE_TYPE.include?(role.default_role_type.to_sym)
          provision_role_policies(role.id, role.default_role_type.to_sym)
        end
      end
      true
    end

    # provision_role_policies
    # @param role_id [Integer]
    # @param key [Symbol]  デフォルトロールの種別情報
    # @return [Boolean]
    def provision_role_policies(role_id, key)
      path = file_path(key.to_s + '_role_policies.json')
      role_data = JSON.parse(File.read(path))
      role_data.deep_symbolize_keys!
      # policyの設定
      role_data[:role_policies].each do |role_policy|
        target_policy = @policy_list.find do |policy|
          policy[:menu] == role_policy[:menu] && policy[:identifier] == role_policy[:identifier]
        end
        next unless target_policy

        level = LOOKUP_POLICY_LEVEL[role_policy[:policy_level].to_sym]
        RolePolicy.find_or_create_by!(role_id: role_id,
                                      policy_id: target_policy[:id],
                                      policy_level: level)
      end
      true
    end

    # 管理者ロールに対して、すべての権限を付与する
    # @param role_id [Integer] 管理者ロールのID
    # @return [Boolean]
    def provision_admin_role_policies(role_id)
      @policy_list.each do |policy|
        RolePolicy.find_or_create_by!(role_id: role_id,
                                      policy_id: policy.id,
                                      policy_level: LOOKUP_POLICY_LEVEL[:edit])
      end
      true
    end

    private

    # シードとなるJSONファイルの取得
    # @return [String]
    def file_path(filename)
      path = ROLE_POLICIES_SEED_DIR.join(@db_connection.account_id.to_s, 'roles', filename)
      return path if File.file?(path)

      ROLE_POLICIES_SEED_DIR.join('default', 'roles', filename)
    end
  end
end
