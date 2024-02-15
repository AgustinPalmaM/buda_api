# frozen_string_literal: true

# Make polling asking current spread vs saved alert spread for the same market
class PollingService
  def polling(market)
    return nil unless permitted?(market)

    current_spread = SpreadService.new.find_spread(market)
    spread_alert = find_alert(market).to_f unless find_alert(market).nil?

    message = set_message(current_spread.to_f, spread_alert)

    { current_spread:, spread_alert:, message: }
  end

  def find_alert(market)
    return nil unless permitted?(market)

    alerts = AlertService.new.load_alerts
    target_alert = alerts.find { |alert| alert['market'] == market }
    target_alert['alert_spread'].to_f unless target_alert.nil?
  end

  def set_message(current_spread, spread_alert)
    return nil unless current_spread.is_a?(Numeric) || current_spread.nil?

    return nil unless spread_alert.is_a?(Numeric) || spread_alert.nil?

    if current_spread.nil?
      'there is not current spread available'
    elsif spread_alert.nil?
      'there is not saved alert spread'
    elsif current_spread > spread_alert
      'current spread is greater than saved alert'
    elsif current_spread < spread_alert
      'current spread is less than saved alert'
    else
      'current spread and saved alert are the same price'
    end
  end

  def permitted?(market)
    Api::V1::Market.permitted?(market)
  end
end
