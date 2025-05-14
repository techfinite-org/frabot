#!/bin/bash

set -e

echo "Updating package list..."
sudo apt update

echo "Installing Google Chrome..."
wget -q -O chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./chrome.deb
rm -f chrome.deb

echo "Downloading matching ChromeDriver..."

# Get Chrome version (trim to major.minor.build)
CHROME_VERSION=$(google-chrome --version | grep -oP '\d+\.\d+\.\d+' | head -1)
echo "🔍 Detected Chrome version: $CHROME_VERSION"

# Try to get matching ChromeDriver version
CHROMEDRIVER_VERSION=$(wget -qO- "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION")

# Fallback to latest if exact match not found
if [ -z "$CHROMEDRIVER_VERSION" ]; then
  echo "⚠️  No exact ChromeDriver version found for $CHROME_VERSION. Using latest available..."
  CHROMEDRIVER_VERSION=$(wget -qO- "https://chromedriver.storage.googleapis.com/LATEST_RELEASE")
fi

echo "Downloading ChromeDriver version: $CHROMEDRIVER_VERSION"

wget -q "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" || {
  echo "Failed to download ChromeDriver."
  exit 1
}

unzip -q chromedriver_linux64.zip
chmod +x chromedriver
sudo mv chromedriver /usr/local/bin/
rm -f chromedriver_linux64.zip

echo "✅ Google Chrome and ChromeDriver installation complete."
