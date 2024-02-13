# frozen_string_literal: true

# this class write into storage/alert.json a spread alert variable and get it also
class AlertService
  ALERT_PATH = Rails.application.config.alert_path

  def self.save_alert(spread, market)
    alert_spreads = load_alerts || []
    alert_spreads.each do |alert|
      next unless alert['market'] == market

      alert['alert_spread'] = spread
      write(alert_spreads)
      return
    end

    alert_spreads << { market: market, alert_spread: spread }
    write(alert_spreads)
  end

  def self.load_alerts
    return nil unless File.exist?(ALERT_PATH)
    
    JSON.parse(File.read(ALERT_PATH))
  end
  
  def self.write(alerts)
    return nil unless File.exist?(ALERT_PATH)
    File.write(ALERT_PATH, JSON.dump(alerts))
  end
end
