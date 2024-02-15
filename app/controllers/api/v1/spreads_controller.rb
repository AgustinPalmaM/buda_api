# frozen_string_literal: true

require 'rest-client'

module Api
  module V1
    # this class manage operations to get spread value, spread all values, make a spread alert and make polling
    class SpreadsController < ApplicationController

      def spread
        market = params[:market]
        if Market.permitted?(market)
          spread = SpreadService.new.find_spread(market)
          render json: { spread: }, status: :ok
        else
          render json: { message: 'invalid parameters' }, status: :bad_request
        end
      end

      def spread_all
        spreads = SpreadService.new.all_spreads
        render json: spreads, status: :ok
      end

      def spread_alert
        spread = params[:spread].to_f
        market = params[:market]
        if spread.positive? && Market.permitted?(market)
          AlertService.save_alert(spread, market)
          render json: { message: 'alert_saved' }, status: :ok
        else
          render json: { message: 'invalid parameters' }, status: :bad_request
        end
      end

      def polling
        market = params[:market]
        if Market.permitted?(market)
          result = PollingService.new.polling(market)
          render json: result, status: :ok
        else
          render json: { message: 'invalid parameters' }, status: :bad_request
        end
      end


    end
  end
end
