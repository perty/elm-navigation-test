#!/usr/bin/env bash

elm-make src/Main.elm --output=app.js

node server.js
