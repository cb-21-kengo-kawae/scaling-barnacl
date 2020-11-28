module TyphoeusApiGateway
  module Platform
    # /platform/api/user_rolesへのAPIアクセスを提供する
    class UserRoleGateway < PlatformGateway
      def show
        client.get("#{base_uri}/#{account_id}")[:body]
      end

      private

      def relative_path
        @relative_path ||= 'user_roles'
      end
    end
  end
end
