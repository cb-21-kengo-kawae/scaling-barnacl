namespace :developments do
  namespace :tester do
    desc '翻訳の過不足をチェックします。'
    task i18n_compare: :environment do
      $LOAD_PATH << Rails.root.join('lib', 'rakes').to_s
      require Rails.root.join('lib', 'rakes', 'test_utils.rb')

      tester = TestUtils::I18nTester.new

      tester.report

      exit tester.valid?
    end
  end
end
