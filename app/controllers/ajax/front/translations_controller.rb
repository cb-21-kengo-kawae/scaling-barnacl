module Ajax
  module Front
    # 翻訳文を配給する。
    class TranslationsController < ApplicationApiController
      include LocalizationControllerSupport

      before_action :set_locale

      def translations
        render json: translations_cache
      end

      private

      def translations_cache
        Rails.cache.fetch(
          [self.class.name, __method__, Settings.version_id, I18n.locale].join('-')
        ) do
          translations_to_hash
        end
      end

      def translations_to_hash(directive = I18n.t('.'))
        directive.each_with_object({}) do |(key, value), translations|
          next if value.is_a?(Proc)

          translations[key] =
            if value.is_a?(Hash)
              translations_to_hash value
            else
              value
            end
        end
      end
    end
  end
end
