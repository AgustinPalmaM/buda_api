# frozen_string_literal: true

require 'test_helper'
module Api
  module V1
    class SpreadsControllerTest < ActionDispatch::IntegrationTest
      test 'should get spread with a valid market' do
        get api_v1_spreads_spread_url(market: 'btc-clp')
        response_json = JSON.parse(response.body)
        assert_response :ok
        assert_match 'application/json', response.content_type
        assert_not_nil JSON.parse(response.body)['spread']
        assert_instance_of Hash, response_json
        assert_includes response_json.keys, 'spread'
        assert_instance_of Float, response_json['spread']
      end

      test 'should not get spread with an invalid market' do
        get api_v1_spreads_spread_url(market: 'btc-cl')
        response_json = JSON.parse(response.body)
        assert_response :bad_request
        assert_match 'application/json', response.content_type
        assert_nil JSON.parse(response.body)['spread']
        assert_instance_of Hash, response_json
        assert_includes response_json.keys, 'message'
        assert_equal 'invalid parameters', response_json['message']
      end

      test 'should get all markets spreads' do
        get api_v1_spreads_all_url
        response_json = JSON.parse(response.body)
        assert_response :ok
        assert_match 'application/json', response.content_type
        assert_not_nil response_json
        assert_instance_of Array, response_json
        response_json.each do |market|
          assert_instance_of Hash, market
          assert_includes market.keys, 'market'
          assert_includes market.keys, 'spread'
          assert_instance_of String, market['market']
          assert_instance_of Float, market['spread']
        end
      end

      test 'should set a spread alert with valid params' do
        get api_v1_spreads_alert_url(spread: 90, market: 'btc-clp')
        response_json = JSON.parse(response.body)
        assert_response :ok
        assert_match 'application/json', response.content_type
        assert_not_nil response_json
        assert_instance_of Hash, response_json
        assert_includes response_json.keys, 'message'
        assert_equal 'alert_saved', response_json['message']
      end

      test 'should not set a spread alert with invalid params' do
        get api_v1_spreads_alert_url(spread: 80, market: 'b-clp')
        response_json = JSON.parse(response.body)
        assert_response :bad_request
        assert_match 'application/json', response.content_type
        assert_not_nil response_json
        assert_instance_of Hash, response_json
        assert_includes response_json.keys, 'message'
        assert_equal 'invalid parameters', response_json['message']
      end

      test 'should make polling with valid params if alert exists' do
        get api_v1_spreads_polling_url(market: 'btc-clp')
        response_json = JSON.parse(response.body)
        assert_response :ok
        assert_match 'application/json', response.content_type
        assert_not_nil response_json
        assert_instance_of Hash, response_json
        assert_includes response_json.keys, 'current_spread'
        assert_includes response_json.keys, 'spread_alert'
        assert_includes response_json.keys, 'message'
        assert_not_nil response_json['spread_alert']
        assert_instance_of Float, response_json['current_spread']
        assert_instance_of Float, response_json['spread_alert']
        assert_instance_of String, response_json['message']
      end

      test 'should not make polling with invalid params if alert exists' do
        get api_v1_spreads_polling_url(market: 'btc-cl')
        response_json = JSON.parse(response.body)
        assert_response :bad_request
        assert_match 'application/json', response.content_type
        assert_not_nil response_json
        assert_instance_of Hash, response_json
        assert_includes response_json.keys, 'message'
        assert_equal 'invalid parameters', response_json['message']
      end
    end
  end
end
