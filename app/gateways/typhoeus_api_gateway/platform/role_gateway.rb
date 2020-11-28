module TyphoeusApiGateway
  module Platform
    # /platform/api/rolesへのAPIアクセスを提供する
    class RoleGateway < PlatformGateway
      def index
        client.get(base_uri, account_id: account_id)[:body]
      end

      private

      def relative_path
        @relative_path ||= 'roles'
      end
    end
  end
end
