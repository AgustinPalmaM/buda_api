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

  test "should return a valid hash with current spread, spread alert and message" do
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

  test "Should return nil if market param is not a permitted market" do
    market = 'btc-brl'
    assert_nil PollingService.new.polling(market)
  end




end
