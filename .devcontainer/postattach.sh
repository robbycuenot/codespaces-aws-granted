#!/bin/bash

# Clear out any existing AWS config
rm -rf ~/.aws
rm -rf ~/.granted

# Create profile for AWS SSO (ct for Control Tower)
mkdir -p ~/.aws
echo "[profile ct]" >> ~/.aws/config
echo "sso_start_url = $AWS_SSO_URL" >> ~/.aws/config
echo "sso_region    = $AWS_REGION" >> ~/.aws/config

# Create granted config
mkdir -p ~/.granted
echo 'DefaultBrowser = "CHROME"' >> ~/.granted/config
echo CustomBrowserPath = \"$BROWSER\" >> ~/.granted/config 
echo CustomSSOBrowserPath = \"\" >> ~/.granted/config
echo Ordering = \"\" >> ~/.granted/config
echo ExportCredentialSuffix = \"\" >> ~/.granted/config

# Log in to AWS SSO
aws sso login --profile ct 

# Populate all AWS SSO accounts/roles
granted sso populate --sso-region $AWS_REGION $AWS_SSO_URL
