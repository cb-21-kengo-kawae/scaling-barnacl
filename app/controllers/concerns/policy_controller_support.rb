# 権限管理に関わるヘルパー
module PolicyControllerSupport
  extend ActiveSupport::Concern

  included do
    include InstanceMethods
    helper_method :policies, :can?, :cannot?, :nothing_tooltip, :css_cannot, :css_disallow
  end

  class NotAuthorizedError < StandardError; end

  # instance methods
  module InstanceMethods
    def policies
      session[:policies] ||= my_policies
    end

    def my_policies
      policies = RolePolicy.policies_for(operator.roles.map(&:id))
      operator.try(:policies) ? policies.merge!(operator.policies.to_h.stringify_keys) : policies
    end

    def reset_policies
      session[:policies] = nil
    end

    def ability_for(policy_identifier)
      policies[policy_identifier.to_s] || :nothing
    end

    def available?(ability, level)
      RolePolicy.policy_levels[ability] >= RolePolicy.policy_levels[level]
    end

    def authorize(policy_identifier, level = :nothing)
      raise NotAuthorizedError unless available?(ability_for(policy_identifier), level)
    end

    ##################
    # helper_method
    ##################

    def can?(level, policy_identifier)
      available? ability_for(policy_identifier), level
    end

    def cannot?(*args)
      !can?(*args)
    end

    def nothing_tooltip
      'disabled policy_tooltip nothing'
    end

    def css_cannot(level, policy_identifier)
      cannot?(level, policy_identifier) ? nothing_tooltip : ''
    end

    def css_disallow(policy_identifier)
      case ability_for(policy_identifier).to_sym
      when :unused, :nothing
        ability_for(policy_identifier)
      end
    end
  end
end
