# タイムゾーン設定のヘルパー
module TimezoneControllerSupport
  extend ActiveSupport::Concern

  private

  def with_time_zone
    tz = operator&.try(:time_zone) ? operator.time_zone : Time.zone.name
    Time.use_zone(tz) { yield }
  end
end
