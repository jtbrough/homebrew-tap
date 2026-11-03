cask "ha-desktop-widget" do
  version "4.1.0"
  sha256 "ffde8a2f1c44eda4e17dc5a6fec223e2d44950a13eda635f85546f2cbb928731"

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
