module Admin
  # 各サービスへのパスを提供する
  module PathHelper
    SERVICE_NAME = Settings.service_name.try(:to_sym)

    SERVICE_NAME_URL_MAP = {
      platform: {
        home: :home,
        web_log_filters: 'data_views/%{data_view_id}/web_log_filters',
        excluded_ip_addresses: 'data_views/%{data_view_id}/excluded_ip_addresses',
        targets: :targets,
        external_tables: :external_tables,
        data_views: :data_views,
        data_views_permitted_ip_addresses: 'data_views/permitted_ip_addresses',
        account: :account,
        access_restrictions: :access_restrictions,
        audiences: :audiences,
        users: :users,
        login_histories: :login_histories,
        roles: :roles,
        ad_agencies: :ad_agencies,
        current_data_view: :current_data_view,
        data_view_logging: :data_view_logging,
        settings: :settings,
        segment_ad_vendors: :segment_ad_vendors,
        ads: :ads,
        universal_tag: :universal_tag,
        permitted_ip_addresses: :permitted_ip_addresses,
        segments: :segments,
        lists: :lists,
        external_services: :external_services,
        ad_vendors: :ad_vendors,
        ad_vendor_accounts: :ad_vendor_accounts,
        goals: :goals,
        sftp_public_keys: :sftp_public_keys,
        domain_settings: :domain_settings,
        sdk_measurement_sets: :sdk_measurement_sets,
        mobile_verify: 'mobile_verify/log',
        mobile_verify_root: :mobile_verify,
        data_export_files: :data_export_files,
        idmappings: 'data_views/%{data_view_id}/idmappings',
        external_table_relations: 'data_views/%{data_view_id}/external_table_relations',
        policy_control_data_managements: 'policy_control/data_managements',
        profile: :profile,
        short_urls: :short_urls,
        aws_accounts: :aws_accounts,
        aws_iams: :aws_iams,
        scoring_behavior_master: 'scorings/behavior_masters',
        common_tag_setting: :common_tag_setting,
        cart_tag_setting: 'data_views/%{data_view_id}/cart_tags'
      },
      report: {
        summaries: :summaries,
        customs: :customs,
        standards: :standards,
        calculations: :calculations,
        aggregates: :aggregates,
        delivery_reports: :delivery_reports,
        data_patterns: :data_patterns,
        setting: :setting,
        setting_data_patterns: 'setting/data_patterns',
        setting_calculations: 'setting/calculations',
        setting_aggregates: 'setting/aggregates',
        setting_delivery_reports: 'setting/delivery_reports'
      },
      action: {
        scenarios: :scenarios,
        scenario_approval_options: 'scenario_approval_options',
        senders: 'mails/senders',
        send_options: 'mails/send_options',
        excluded_addresses: 'mails/excluded_addresses',
        push_clients: 'pushes/clients',
        push_send_options: 'pushes/send_options',
        line_channels: 'lines/channels',
        line_send_options: 'lines/send_options',
        sms_senders: 'smses/senders',
        win_push_clients: 'win_pushes/clients',
        win_push_send_options: 'win_pushes/send_options',
        yappli_clients: 'yapplies/clients',
        yappli_send_options: 'yapplies/send_options'
      },
      sfa: {
        projects: :projects,
        companies: :companies,
        merchandises: :merchandises,
        sales_representatives: :sales_representatives,
        business_files: :business_files,
        leads: :leads
      },
      contents: {
        sites: :sites,
        themes: :themes,
        creatives: :creatives,
        form_respondents: :form_respondents,
        senders: :senders,
        recipients: :recipients,
        csr: :csr,
        settings: :settings
      },
      clerk: {
        split_run_tests: :split_run_tests,
        receptions: :receptions_top,
        setting_split_run_tests_tag: 'setting/split_run_tests_tag',
        setting_receptions_preview_customers: 'setting/receptions_preview_customers',
        setting_receptions_tag: 'setting/receptions_tag'
      },
      recommend: {
        top: :top,
        data_mappings: :data_mappings
      },
      preparation: {
        data_sources: :data_sources
      },
      billing: {
        top: :top
      },
      bi: {
        top: 'bi'
      },
      crm: {
        top: 'crm'
      },
      scoring: {
        top: 'scoring'
      }
    }.freeze

    ADMIN_SERVICE_NAME_URL_MAP = {
      admin: {
        services: 'oauth/applications',
        dashboard: :dashboard
      },
      auth: {
        services: 'oauth/applications',
        dashboard: 'admin/dashboard'
      },
      platform: {
        dashboard: 'admin/dashboard'
      },
      report: {
        dashboard: 'admin/dashboard'
      },
      action: {
        dashboard: 'admin/dashboard'
      },
      delivery: {
        dashboard: 'admin/dashboard'
      },
      contents: {
        dashboard: 'admin/dashboard'
      },
      recommend: {
        dashboard: 'admin/dashboard'
      },
      clerk: {
        dashboard: 'admin/dashboard'
      },
      scoring: {
        dashboard: 'admin/dashboard'
      },
      preparation: {
        dashboard: 'admin/dashboard'
      }
    }.freeze

    # @param service_name [String, Symbol] サービス名
    # @param resource_name [String, Symbol] リソース名
    # @option options [Hash] 置換文字のキー、バリュー
    # @return [String] パス
    def app_path(service_name, resource_name = nil, options = {})
      AppGuide.new(service_name, resource_name).path(options)
    end

    # @param service_name [String, Symbol] サービス名
    # @param resource_name [String, Symbol] リソース名
    # @option options [Hash] 置換文字のキー、バリュー
    # @return [String] パス
    def app_admin_path(service_name, resource_name = nil, options = {})
      AdminGuide.new(service_name, resource_name).path(options)
    end

    def service_name
      SERVICE_NAME
    end

    def external_service?(name)
      service_name != name.to_sym
    end

    def rel_external(name)
      external_service?(name) ? 'external' : nil
    end

    def zelda_resource_label_list(resource, input_name = :zelda_label)
      selected_labels = if params[input_name].nil?
                          resource.labels.map(&:jsonify_hash)
                        else
                          resource.sanitize_labels(params[input_name])
                        end

      {
        labelList: Label.where(data_view_id: current_donkey_user[:current_view_id]).map(&:jsonify_hash),
        selectedLabels: selected_labels,
        resourceId: resource.id
      }.to_json
    end

    def active_class(path)
      url = URI.parser.unescape(url_for)
      url == path || url.start_with?(path + '/') ? 'active' : ''
    end
  end
end
