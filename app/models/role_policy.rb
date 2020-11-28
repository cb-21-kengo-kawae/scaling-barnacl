# 権限セットを扱うModel
class RolePolicy < AccountRecord
  enum policy_level: { unused: 0, nothing: 1, read_only: 2, edit: 3 }
  scope :summarized_policies, ->(role_ids) { where(role_id: role_ids).group(:policy_id).maximum(:policy_level) }

  class << self
    def display_policy_levels
      policy_levels.keys.reject { |level| level == 'unused' }
    end

    def policies_for(role_ids)
      policies = summarized_policies(role_ids)
      Policy.order(:id).map do |policy|
        [policy.identifier, policies[policy.id].present? ? policies[policy.id] : 'nothing']
      end.to_h
    end
  end
end
