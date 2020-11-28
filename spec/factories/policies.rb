FactoryBot.define do
  factory :policy do
    name { 'アカウント管理' }
    name_en { 'Accounts' }
    identifier { 'accounts' }
    menu { 'settings' }
    policy_type { :menu }

    factory :data_management_app_policy do
      identifier { 'p_data_management' }
      menu { 'data_management' }
      policy_type { :app }
    end

    factory :settings_app_policy do
      identifier { 'p_settings' }
      menu { 'settings' }
      policy_type { :app }
    end

    factory :preparation_app_policy do
      identifier { 'p_preparation' }
      menu { 'preparation' }
      policy_type { :app }
    end

    factory :bi_app_policy do
      name { 'BI' }
      name_en { 'BI' }
      identifier { 'p_bi' }
      menu { 'bi' }
      policy_type { :app }
    end

    factory :crm_app_policy do
      name { 'CRM' }
      name_en { 'CRM' }
      identifier { 'p_crm' }
      menu { 'crm' }
      policy_type { :app }
    end

    factory :scoring_app_policy do
      name { 'Scoring' }
      name_en { 'Scoring' }
      identifier { 'p_scoring' }
      menu { 'scoring' }
      policy_type { :app }
    end
  end
end
