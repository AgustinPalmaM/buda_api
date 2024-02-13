# frozen_string_literal: true

# Make polling asking current spread vs saved alert spread for the same market
class PollingService


  def polling(market)
    current_spread = SpreadService.new.find_spread(market)
    spread_alert = find_alert(market)

    message = set_message(current_spread, spread_alert)

    { current_spread:, spread_alert:, message: }
  end

  def find_alert(market)
    alerts = AlertService.load_alerts
    target_alert = alerts.find { |alert| alert['market'] == market }
    target_alert['alert_spread'] unless target_alert.nil?
  end

  def set_message(current_spread, spread_alert)
    if spread_alert.nil?
      'there is not saved alert spread'
    elsif current_spread > spread_alert
      'current spread is greater than saved alert'
    elsif current_spread < spread_alert
      'current spread is less than saved alert'
    else
      'current spread and saved alert are the same price'
    end
  end
end
