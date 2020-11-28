module Admin
  module PathHelper
    # `zelda-admin` 向けのパスを提供する
    class AdminGuide < PathGuide
      private

      def path_map
        ADMIN_SERVICE_NAME_URL_MAP
      end
    end
  end
end
