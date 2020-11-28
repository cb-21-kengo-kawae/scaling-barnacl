module TyphoeusApiGateway
  module Platform
    # APIアクセスを提供する
    class PlatformGateway < BaseGateway
      private

      def relative_url_root
        Settings.services.platform.relative_url_root
      end
    end
  end
end
