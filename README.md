[![CI](https://github.com/invalidusrname/weather_app/actions/workflows/ci.yml/badge.svg)](https://github.com/invalidusrname/weather_app/actions/workflows/ci.yml)

# Weather App

A small app that tells you the weather for a zip code

![Weather Form](public/form.png)
![Weather Forecast](public/forecast.png)

## Setup

Install dependencies

```
./bin/setup
```

## Running

Run the app locally in development mode

```
./bin/dev
```

If you do not have the master.key setup or available, you'll need to register with [weatherapi.com](https://www.weatherapi.com/) and get an API key. Use `WEATHER_API_TOKEN` as an ENV var for fetching the weather:

```
WEATHER_API_TOKEN=88888CHANGEME8888888 ./bin/dev
```

## Tests

Run the specs

```
bundle exec rspec
```
