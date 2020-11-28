module Admin
  module PathHelper
    # パスを提供するベースクラス
    class PathGuide
      # @param service_name [String, Symbol] サービス名
      # @param resource_name [String, Symbol] リソース名
      def initialize(service_name, resource_name = nil)
        @service_name = service_name.to_sym
        @path_set = path_map[@service_name]

        raise ArgumentError, "service_name: #{@service_name} is not defined" unless @path_set

        @resource_name = resource_name&.to_sym
        @resource_path = @path_set[@resource_name]

        raise ArgumentError, "resource_name: #{@resource_name} is not defined" if @resource_name && !@resource_path

        @path_format = [@service_name, @resource_path].compact.join('/')
      end

      # パスフォーマットが `path/to/%{id}/resource` のようにリプレースメントを持っている場合は置換できる。
      #
      # @option options [Hash] 置き換え文字があればキー、バリューを指定する
      # @return [String]
      def path(options = {})
        "/#{@path_format % options}"
      end

      private

      def path_map
        raise NotImplementedError
      end
    end
  end
end
