#!/bin/bash

TOKEN=$(cat ~/.terraform.d/credentials.tfrc.json | jq -r '.credentials["app.terraform.io"].token')

PLAN_ID=$(curl -s \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --location \
  https://app.terraform.io/api/v2/runs/${1} | jq -r '.data.relationships.plan.data.id')

curl -s \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --location \
  https://app.terraform.io/api/v2/plans/$PLAN_ID/json-output > json-output.json
