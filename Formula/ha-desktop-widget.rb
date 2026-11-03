class HaDesktopWidget < Formula
  desc "Lightweight Home Assistant desktop widget (Rainmeter-style)"
  homepage "https://github.com/Robertg761/HA-Desktop-Widget"
  url "https://github.com/Robertg761/HA-Desktop-Widget/releases/download/v#{version}/HA-Desktop-Widget-#{version}-linux-x86_64.AppImage",
      verified: "github.com/Robertg761/HA-Desktop-Widget/"
  version "4.1.0"
  sha256 "41042e72b401ad27a9e619ef86b17053a30b0e217fbca87b2efa8d149d5e0501"

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
