namespace :developments do
  namespace :node_js do
    desc 'node.js 用に翻訳を書き出します。'
    task translations: :environment do
      translations = {}
      dir = Rails.root.join('app', 'javascript', 'src', 'locales', 'rails')

      FileUtils.mkdir_p dir.to_s unless dir.directory?

      Settings.available_locales.each do |lang|
        I18n.with_locale(lang) do
          translations[lang] = { translation: I18n.t('.').except(:faker, :ransack, :i18n, :number, :grape) }
        end
      end

      File.write(dir.join('rails-translations.yml'), YAML.dump(translations.deep_stringify_keys))
    end
  end
end
