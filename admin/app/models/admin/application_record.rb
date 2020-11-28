module Admin
  # ApplicationRecord Admin
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
