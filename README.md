# ScanChat-app

Web application for the ScanChat system that enables users to create one-time-use chatrooms or message boards, designed specifically for short-term communication needs. This application allows users to quickly and securely share messages or ideas within a limited timeframe, ensuring privacy and information security while encouraging timely and instant communication.

Please also note the Web API that it uses: https://github.com/SECutiee/ScanChat-api

## Install

Install this application by cloning the *relevant branch* and use bundler to install specified gems from `Gemfile.lock`:

```shell
bundle install
```

## Test

This web app does not contain any tests yet :(

## Execute

Launch the application using:

```shell
rake run:dev
```

The application expects the API application to also be running (see `config/app.yml` for specifying its URL)