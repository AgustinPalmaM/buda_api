Buda Api

This is a ruby on rails project maded to work with the Buda cryptocurrency market API, you can call ti the endpoints to get a spread for a specific market, or get all market spreads or set an alert for a specific value and market,then you can make polling to this alert to know if your alert is up or down the current spread.

## Installation

To use this repo in your local machine, you have to clone it running the next command:

```
git clone https://github.com/AgustinPalmaM/buda_api.git
```

Then install all dependencies into the gemfile running:

```
$ bundle install
```

## Usage

This object has four routes to get the data, you can run rails routes and get all the information:

```
>>rails routes
                Prefix Verb  URI Pattern                       Controller#Action
  api_v1_spreads_spread GET  /api/v1/spreads/spread(.:format)  api/v1/spreads#spread
     api_v1_spreads_all GET  /api/v1/spreads/all(.:format)     api/v1/spreads#spread_all
   api_v1_spreads_alert GET  /api/v1/spreads/alert(.:format)   api/v1/spreads#spread_alert
 api_v1_spreads_polling GET  /api/v1/spreads/polling(.:format) api/v1/spreads#polling
```

All the api endpoints are for public calls, so you don't need authentication to get the result

The first endpoint is ```http://localhost:3000/api/v1/spreads/spread?market=btc-clp```, here we have to pass the valid market to get the current spread, the response is a the next hash

```
{"spread":438305.0}
```
To know the validate markets we have a model called Market where we keep an Array with all the markets

```
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
```

When we call the endpoint with invalid market, we receive a hash with the next data:

```
{ "message":	"invalid parameters" }

```
The second endpoint is ```http://localhost:3000/api/v1/spreads/all```, here we don't need to pass any param or market because this endpoint return the spreads for all the markets present in the buda api, the response is an Array of hashes:

```
[
  {
    "market":"bch-clp",
    "spread":8797.31},
  {
    "market":"btc-clp",
    "spread":433729.0},
  {
    "market":"ltc-pen",
    "spread":12.88},
  {
    "market":"btc-cop",
    "spread":5999132.99}
  ]
```
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).