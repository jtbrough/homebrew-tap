cask "ha-desktop-widget" do
  version "3.10.0"
  sha256 "d8a638c2c2ba97d59aa417a0633630d0af79e0c795d12cf8efdf8dfa4003287b"

  url "https://github.com/Robertg761/HA-Desktop-Widget/releases/download/v#{version}/HA-Desktop-Widget-#{version}-universal.dmg"
  name "HA Desktop Widget"
  desc "Lightweight Home Assistant desktop widget (Rainmeter-style)"
  homepage "https://github.com/Robertg761/HA-Desktop-Widget"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "HA Desktop Widget.app"

  zap trash: [
    "~/Library/Application Support/ha-desktop-widget",
    "~/Library/Logs/ha-desktop-widget",
    "~/Library/Preferences/ca.rgprojectdump.ha-desktop-widget.plist",
  ]
end
