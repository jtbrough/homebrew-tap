class HaDesktopWidget < Formula
  desc "Lightweight Home Assistant desktop widget (Rainmeter-style)"
  homepage "https://github.com/Robertg761/HA-Desktop-Widget"
  url "https://github.com/Robertg761/HA-Desktop-Widget/releases/download/v#{version}/HA-Desktop-Widget-#{version}-linux-x86_64.AppImage",
      verified: "github.com/Robertg761/HA-Desktop-Widget/"
  version "3.9.1"
  sha256 "21aad8dcd52f72a1b70542bc614e76aa85d98926515e34ba91e9e9586ea85e67"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  def install
    appimage = "HA-Desktop-Widget-#{version}-linux-x86_64.AppImage"
    bin.install appimage => "ha-desktop-widget"
    (bin/"ha-desktop-widget").chmod(0755)
  end

  test do
    assert_path_exists bin/"ha-desktop-widget"
  end
end
