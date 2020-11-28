module TestUtils
  # I18n のキーに過不足がないかチェックする
  class I18nTester
    attr_accessor :ignore_keys

    DEFAULT_IGNORE_KEYS = %w(
      i18n[.] faker[.] grape[.]
      (translation[.])?number[.]human
      (translation[.])?time[.]formats[.]us
      (translation[.])?number[.]human[.]storage_units[.]units[.]byte[.]
      (translation[.])?errors[.]messages[.]too_long[.]
      (translation[.])?errors[.]messages[.]too_short[.]
      (translation[.])?errors[.]messages[.]wrong_length[.]
      (translation[.])?errors[.]messages[.]carrierwave_
      (translation[.])?errors[.]messages[.]extension_
      (translation[.])?errors[.]messages[.]rmagick_
      (translation[.])?errors[.]messages[.]mime_types_
      (translation[.])?errors[.]messages[.]mini_magick_
      (translation[.])?errors[.]unavailable_session
      (translation[.])?errors[.]unacceptable_request
      (translation[.])?errors[.]connection_refused
      (translation[.])?errors[.]or
      (translation[.])?errors[.][^.]+[?]
      (translation[.])?multibyte
      (translation[.])?helpers[.]page_entries_info[.]
      (translation[.])?views[.]pagination[.]
    ).freeze

    def initialize
      I18n.load_path = Dir[Rails.root.join('app', 'javascript', 'src', 'locales', '**', '*.{yml}')]
      i18n_backend.send :init_translations
      self.ignore_keys = DEFAULT_IGNORE_KEYS
    end

    def check
      return @check if @check

      keys_each_locales = {}
      all_keys = []

      available_locales.each do |locale|
        key_list = keys(translations[locale.to_sym])
        keys_each_locales[locale] = key_list
        all_keys |= key_list
      end

      ignore_regex = /^(#{ignore_keys.join('|')})/

      @check =
        all_keys.each_with_object({}) do |key, result|
          next if key =~ ignore_regex

          begin
            available_locales.each do |locale|
              I18n.with_locale(locale) do
                I18n.t! key
              end
            end
          rescue I18n::MissingTranslationData
            result[key] =
              available_locales.each_with_object({}) do |locale, res|
                I18n.with_locale(locale) do
                  res[locale] = begin
                                  I18n.t!(key)
                                rescue StandardError
                                  false
                                end
                end
              end
          end
        end
    end

    def report
      puts "\n\n"
      check.each do |key, diff|
        puts "  \e[32m#{key}\e[0m"
        diff.each do |locale, translation|
          message =
            if translation == false
              "    \e[31m#{locale}: \e[0m"
            else
              "    #{locale}: #{translation.to_s.tr("\n", ' ')}"
            end

          puts message
        end
        puts "\n"
      end

      count_msg =
        if count.positive?
          "\e[31m#{count}\e[0m"
        else
          "\e[32m#{count}\e[0m"
        end

      puts "  detect: #{count_msg}\n\n"
    end

    def valid?
      check.empty?
    end

    def invalid?
      !valid?
    end

    def count
      check.size
    end

    private

    delegate(:available_locales, to: :Settings)
    private(:available_locales)

    def keys(target, path = nil)
      target.each_with_object([]) do |(key, scoped), result|
        scope = path ? "#{path}.#{key}" : key

        if scoped.is_a?(Hash)
          result.concat keys(scoped, scope)
        else
          result << scope
        end
      end
    end

    def translations
      @translations ||= i18n_backend.send(:translations)
    end

    def i18n_backend
      @i18n_backend ||= I18n.config.backend
    end
  end
end
