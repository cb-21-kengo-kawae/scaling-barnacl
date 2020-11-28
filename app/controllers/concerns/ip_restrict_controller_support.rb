# IPアドレス制限に関わるヘルパー
module IpRestrictControllerSupport
  extend ActiveSupport::Concern

  class NotAuthorizedError < StandardError; end

  def restrict_ip_address
    raise NotAuthorizedError if ip_whitelist.present? && ip_whitelist.exclude?(request.remote_ip)
  end

  private

  def ip_whitelist
    @ip_whitelist ||= operator.ip_whitelist
  end
end
