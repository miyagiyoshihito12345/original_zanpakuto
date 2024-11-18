#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Node.js 23.2.0 using NVM
if ! command -v node &>/dev/null; then
  echo "Installing Node.js 23.2.0..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
  source ~/.nvm/nvm.sh
  nvm install 23.2.0
  nvm use 23.2.0
fi

# Proceed with the rest of the build steps
bundle install
bundle exec rake assets:precompile  
bundle exec rake assets:clean
bundle exec rake db:migrate
