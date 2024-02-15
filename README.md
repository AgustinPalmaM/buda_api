#Buda Api

## Built with

![Ruby on Rails Logo](https://upload.wikimedia.org/wikipedia/commons/thumb/1/16/Ruby_on_Rails-logo.png/220px-Ruby_on_Rails-logo.png)

This is a ruby on rails project maded to work with the <a>href="https://api.buda.com/#la-api-de-buda-com">Buda cryptocurrency market API<a>, you can call ti the endpoints to get a spread for a specific market, or get all market spreads or set an alert for a specific value and market,then you can make polling to this alert to know if your alert is up or down the current spread.

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

All the api endpoints are for public calls, so you don't need authentication to get the result, the method for the four endpoints is GET

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
{ "message": "invalid parameters" }
```
The second endpoint is ```http://localhost:3000/api/v1/spreads/all```, here we don't need to pass any param or market because this endpoint return the spreads for all the markets present in the buda api, the response is an Array of hashes:

```
[
  {
    "market":"bch-clp",
    "spread":8797.31},
  {
    "market":"btc-clp",
    "spread":433729.0}
  {
    "market":"ltc-pen",
    "spread":12.88}
  {
    "market":"btc-cop",
    "spread":5999132.99}
  ]
```
The third endpoint is ```http://localhost:3000/api/v1/spreads/alert?spread=8&market=btc-clp```, here we have to pass an spread value and a market value to set an alert with this params, the response is a hash:

```
{ "message":"alert_saved" }
```

and this action save the data into a json file called alert.json into the storage folder of the project;

```
[
  {
    "market": "btc-clp",
    "alert_spread": 8.0
  }
]
```
If the alert what we are to trying to save is a new alert for a new market the action save a new alert with the params passed, but if the alert is a new value for an existing market alert, so the action replace the old value with the new one.
If we pass invalid parameters like numbers under zero o invalid markets, we receive a response with a hash:

```
{ "message":"invalid parameters" }
```
The fourth endpoint is to make polling to a saved alert previously ```http://localhost:3000/api/v1/spreads/polling?market=btc-clp```, we have to pass the market where we want to make polling, so the action get the current spread and compare with the saved alert and throw a response with a hash with the current_spread, spread_alert and message:

```
{
  "current_spread":488093.0,
  "spread_alert":8.0,"message":
  "current spread is greater than saved alert"
}
```
If we pass an invalid market params, we receive a hash response like this:

```
{ "message":"invalid parameters" }
```
If we don't have an alert for the params market passed, we receive a hash with the next values:

```
{
  "current_spread":0.0,
  "spread_alert":null,
  "message":"there is not saved alert spread"
}
```
