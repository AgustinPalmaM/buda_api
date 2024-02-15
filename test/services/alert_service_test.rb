# frozen_string_literal: true

require 'test_helper'

class AlertServiceTest < ActiveSupport::TestCase
  ALERT_PATH = Rails.application.config.alert_path

  setup do
    default_alert = { "market": 'btc-clp', "alert_spread": 9 }
    File.write(ALERT_PATH, JSON.dump([default_alert]))
    @alert = AlertService.new
  end

  teardown do
    default_alert = { "market": 'btc-clp', "alert_spread": 9 }
    File.write(ALERT_PATH, JSON.dump([default_alert]))
  end

  test 'should save new alert when passing a new market' do
    @alert.save_alert(80, 'btc-cop')
    alerts = @alert.load_alerts
    assert_equal 2, alerts.size
    assert_instance_of Array, alerts
    alerts.each do |alert|
      assert_instance_of Hash, alert
      assert_includes alert.keys, 'market'
      assert_includes alert.keys, 'alert_spread'
    end
    assert_equal({ "market": 'btc-clp', "alert_spread": 9 }, alerts.first.symbolize_keys)
    assert_equal({ "market": 'btc-cop', "alert_spread": 80 }, alerts.last.symbolize_keys)
  end

  test 'should not save a new alert when passing an existing market, should rewrite alert_spread value' do
    @alert.save_alert(8000, 'btc-clp')
    alerts = @alert.load_alerts
    assert_equal 1, alerts.size
    assert_instance_of Array, alerts
    alerts.each do |alert|
      assert_instance_of Hash, alert
      assert_includes alert.keys, 'market'
      assert_includes alert.keys, 'alert_spread'
    end
    assert_equal({ "market": 'btc-clp', "alert_spread": 8000 }, alerts.first.symbolize_keys)
  end

  test 'should load alerts when path to file alert_test.json is valid' do
    alerts = @alert.load_alerts
    assert_not_nil alerts
    assert_instance_of Array, alerts
    assert_equal 1, alerts.size
    assert_equal 'btc-clp', alerts.first['market']
    assert_equal 9, alerts.first['alert_spread']
  end

  test 'should not load alerts from a nil path' do
    File.delete(ALERT_PATH)
    alerts = @alert.load_alerts
    assert_nil alerts
  end

  test 'should write alerts to an existing file' do
    alerts = [{ "market": 'btc-clp', "alert_spread": 1000 }, { "market": 'btc-ars', "alert_spread": 9000 }]
    @alert.write(alerts)
    file_content = JSON.parse(File.read(ALERT_PATH))
    assert_equal 2, file_content.size
    assert_equal 'btc-clp', file_content.first['market']
    assert_equal 1000, file_content.first['alert_spread']
    assert_equal 'btc-ars', file_content.last['market']
    assert_equal 9000, file_content.last['alert_spread']
  end

  test 'should not write when a valid json file does not exist' do
    File.delete(ALERT_PATH)
    alerts = [{ "market": 'btc-clp', "alert_spread": 1000 }, { "market": 'btc-ars', "alert_spread": 9000 }]
    assert_nil @alert.write(alerts)
  end
end
