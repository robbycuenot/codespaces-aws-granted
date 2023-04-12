# Overview

This repository contains a basic Github Codespaces configuration that is purpose-built for AWS Control Tower / SSO Organizations. The goal is to go from clicking "Create Codespace" to working in the target AWS account / role with the fewest actions possible, while maintaining security best-practices.

This repo leverages [common-fate/granted](https://github.com/common-fate/granted) for credential management. Most features of granted are working properly; however, the Firefox extension is currently not.

See an example Codespace setup below:

![demo](https://user-images.githubusercontent.com/51327557/231294401-09a29e28-3c71-416d-89f6-e82cafe2e7f8.gif)

# Setup
1. Fork or copy the code from this repo
2. Add two Codespace Secrets
    1. `AWS_SSO_URL` - ex. https://yourorg.awsapps.com/start
    2. `AWS_REGION` - ex. us-east-1
3. Launch the Codespace!

# Additional Notes
The login process is effectively:
1. Run `aws sso login` using the start URL provided
2. Pass the oauth prompt to the codespaces browser redirect
3. Grant access in the local browser
4. Run `granted populate` to generate the list of all accounts/roles
5. Provide a password to locally encrypt the AWS config, if you wish
6. Run `assume` to select an account/role
7. Run `assume -ar` to open the current role in-browser
