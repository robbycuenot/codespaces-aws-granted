#!/bin/bash

# --noprompt flag = Skip the "Would you like to sign into AWS SSO? (y/n)" prompt"
# --force flag = Force the script to run even if AUTORUN = false
while [ $# -gt 0 ]; do
    case "$1" in
        --noprompt)
            noprompt=true
            ;;
        --force)
            force=true
            ;;
        *)
            ;;
    esac
    shift
done

# If AUTORUN = false and --force flag is not set, exit
if [ "$AUTORUN" = "false" ]; then
    if [  -z  "$force" ]; then
        exit 0
    fi
fi

# Ask if the user would like to sign into aws sso (y or yes or Y or Yes), or if n or no or N or No, exit
# If noprompt = true, skip this step
if [  -z  "$noprompt" ]; then
    read -p "Would you like to sign into AWS SSO? (y/n): " AWS_SSO
    if [[ $AWS_SSO =~ ^[Yy][Ee][Ss]$ ]] || [[ $AWS_SSO =~ ^[Yy]$ ]]; then
        echo "Starting AWS SSO login..."
    elif [[ $AWS_SSO =~ ^[Nn][Oo]$ ]] || [[ $AWS_SSO =~ ^[Nn]$ ]]; then
        echo "Login flow cancelled. To sign in later, run 'awslogin'"
        exit 0
    else
        echo "Invalid input, exiting. To sign in later, run 'awslogin'"
        exit 1
    fi
else
    echo "Starting AWS SSO login..."
fi

# If AWS_SSO_URL and AWS_REGION are not set, prompt for those values
if [ -z "$AWS_SSO_URL" ]; then
    read -p "Enter AWS SSO URL: " AWS_SSO_URL
    # if the value entered doesn't match this pattern, throw an error and exit
    if [[ ! $AWS_SSO_URL =~ ^https://.*awsapps.com.*$ ]]; then
        echo "Invalid AWS SSO URL, exiting. To try again, run 'awslogin'"
        exit 1
    fi
fi

if [ -z "$AWS_REGION" ]; then
    read -p "Enter AWS Region: " AWS_REGION
     # if the value entered doesn't match this pattern, throw an error and exit
    if [[ ! $AWS_REGION =~ ^[a-z]{2}-[a-z]{4,9}-[0-9]$ ]]; then
        echo "Invalid AWS Region, exiting. To try again, run 'awslogin'"
        exit 1
    fi
fi

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
