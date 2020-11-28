# BaseForm
class BaseForm
  VirtusMixin = Virtus.model
  include VirtusMixin
  include ActiveModel::Validations
end
