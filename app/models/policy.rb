# 権限を扱うModel
class Policy < ApplicationRecord
  validates :name, presence: true

  enum policy_type: { menu: 0, func: 1, app: 2 }
end
