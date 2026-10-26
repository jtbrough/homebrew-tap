cask "ha-desktop-widget" do
  version "4.0.2"
  sha256 "732ac20e86f7ed88f3c9c9d7b595e9306ecdd6f6f261fe72c0396226d274e296"

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
