cask "ha-desktop-widget" do
  version "3.8.0"
  sha256 "dbb59d4357a079e6b168c281caa7745bde96bc86b5e6e5d9909506a5e4e8f09a"

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
