module Admin
  # Admin ApplicationHelper
  module ApplicationHelper
    include PathHelper

    def ldate(dt, hash = {})
      dt ? l(dt, hash) : nil
    end
  end
end
