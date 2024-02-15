# frozen_string_literal: true

module Api
  module V1
    # A class to keep all validate markets present in the API
    class Market
      PERMITTED_MARKETS = %w[
        btc-clp
        btc-cop
        eth-clp
        eth-btc
        btc-pen
        eth-pen
        eth-cop
        bch-btc
        bch-clp
        bch-cop
        bch-pen
        btc-ars
        eth-ars
        bch-ars
        ltc-btc
        ltc-clp
        ltc-cop
        ltc-pen
        ltc-ars
        usdc-clp
        usdc-cop
        usdc-pen
        usdc-ars
        btc-usdc
        usdt-usdc
      ].freeze

      def self.permitted?(market)
        PERMITTED_MARKETS.include?(market)
      end
    end
  end
end
