# frozen_string_literal: true

require 'rest-client'

# class to make calls to external api to get spread values
class SpreadService
  BASE_URL = 'https://www.buda.com/api/v2/markets'
  def find_spread(market)
    return nil unless Api::V1::Market.permitted?(market)

    data = call_url("#{BASE_URL}/#{market}/ticker")

    min_ask = data['ticker']['min_ask'][0].to_f
    max_bid = data['ticker']['max_bid'][0].to_f
    spread = min_ask - max_bid
    spread.round(2)
  end

  def all_spreads
    threads = []
    spreads = []

    validate_markets.each do |market|
      threads << Thread.new do
        spread = find_spread(market)
        spreads << { market:, spread: }
      end
    end

    threads.each(&:join)

    spreads
  end

  def call_url(url)
    return nil unless validate_url?(url)

    response = RestClient.get(url)
    JSON.parse(response.body)
  end

  def validate_url?(url)
    validates_urls = []
    validate_markets.each do |market|
      validate_url = "#{BASE_URL}/#{market}/ticker"
      validates_urls << validate_url
    end
    validates_urls.include?(url)
  end

  def validate_markets
    Api::V1::Market::PERMITTED_MARKETS
  end
end
