require 'rest-client'

class Api::V1::SpreadsController < ApplicationController
  def spread(market)
    render json: {response: RestClient.get('https://www.buda.com/api/v2/markets/btc-clp/order_book.json') }
  end

  def spread_all_markets

  end

  def spread_alert
    
  end
end
