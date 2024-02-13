# frozen_string_literal: true

require 'test_helper'

class PollingServiceTest < ActiveSupport::TestCase
  ALERT_PATH = Rails.application.config.alert_path

  setup do
    default_alert = { "market": 'btc-clp', "alert_spread": 9 }
    File.write(ALERT_PATH, JSON.dump([default_alert]))
  end

  teardown do
    default_alert = { "market": 'btc-clp', "alert_spread": 9 }
    File.write(ALERT_PATH, JSON.dump([default_alert]))
  end

  test 'should return a valid hash with current spread, spread alert and message' do
    market = 'btc-clp'
    polling = PollingService.new.polling(market)
    assert polling
    assert_instance_of Hash, polling
    assert_includes polling.keys, :current_spread
    assert_includes polling.keys, :spread_alert
    assert_includes polling.keys, :message
    assert_instance_of Float, polling[:current_spread]
    if polling[:alert_spread]
      assert_instance_of Float, polling[:alert_spread]
    else
      assert_nil polling[:alert_spread]
    end
    assert_instance_of String, polling[:message]
  end

  test 'Should return nil if market param is not a permitted market' do
    market = 'btc-brl'
    assert_nil PollingService.new.polling(market)
  end

  test 'Should return alert value if alert market is saved for the market given' do
    market = 'btc-clp'
    alert_target = PollingService.new.find_alert(market)
    assert alert_target
    assert_instance_of Float, alert_target
    assert_equal 9.0, alert_target
  end

  test 'Should return nil when is not saved an alert for the market given' do
    market = 'btc-cop'
    alert_target = PollingService.new.find_alert(market)
    assert_nil alert_target
  end

  test 'Should return nil when pass an invalid market' do
    market = 'btc-cap'
    alert_target = PollingService.new.find_alert(market)
    assert_nil alert_target
  end

  test 'return valid messages when pass numeric or nil params current_spread or spread_alert' do
    assert_equal 'there is not current spread available', PollingService.new.set_message(nil, 1)
    assert_equal 'there is not saved alert spread', PollingService.new.set_message(1, nil)
    assert_equal 'current spread is greater than saved alert', PollingService.new.set_message(10, 1)
    assert_equal 'current spread is less than saved alert', PollingService.new.set_message(1, 10)
    assert_equal 'current spread and saved alert are the same price', PollingService.new.set_message(1, 1)
  end

  test 'return nil when pass not numeric or nil value to params current_spread or spread_alert' do
    assert_nil PollingService.new.set_message('1', '1')
    assert_nil PollingService.new.set_message('1', nil)
    assert_nil PollingService.new.set_message(10, [])
    assert_nil PollingService.new.set_message('1', [])
    assert_nil PollingService.new.set_message({}, 1)
  end
end
