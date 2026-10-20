cask "ha-desktop-widget" do
  version "4.0.0"
  sha256 "4dd22b545d37d40a65023c183dcb7632885f8d567c13bc0f0414e4905b3ab035"

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
