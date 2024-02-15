# frozen_string_literal: true

require 'test_helper'
class SpreadServiceTest < ActiveSupport::TestCase
  setup do
    @spread_service = SpreadService.new
  end

  test 'Should_find_spread_with_a valid_market' do
    spread = @spread_service.find_spread('btc-clp')

    assert spread
    assert_instance_of Float, spread
    assert_operator spread, :>=, 0
  end

  test 'Should not_find_spread_with_invalid_market' do
    spread = @spread_service.find_spread('btc-clc')

    assert_nil spread
  end

  test 'Should get all spread market' do
    spreads = @spread_service.all_spreads

    assert spreads
    assert_instance_of Array, spreads
    spreads.each do |spread|
      assert spread
      assert_instance_of Hash, spread
      assert_includes spread.keys, :market
      assert_includes spread.keys, :spread
      assert_instance_of String, spread[:market]
      assert_instance_of Float, spread[:spread]
      assert_operator spread[:spread], :>=, 0
    end
  end

  test "should fetch a valid url" do
    market = 'btc-clp'
    base_url = SpreadService::BASE_URL
    url = "#{base_url}/#{market}/ticker"
    response = @spread_service.call_url(url)
    
    assert response
    assert_not_empty response
    assert_instance_of Hash, response
    
    
  end

  test "should noy fetch an invalid url" do
    invalid_url = 'https://www.loteria.com'
    response = @spread_service.call_url(invalid_url)
    
    assert_nil response
  end
end
