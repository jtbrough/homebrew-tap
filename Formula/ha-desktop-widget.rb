class HaDesktopWidget < Formula
  desc "Lightweight Home Assistant desktop widget (Rainmeter-style)"
  homepage "https://github.com/Robertg761/HA-Desktop-Widget"
  url "https://github.com/Robertg761/HA-Desktop-Widget/releases/download/v#{version}/HA-Desktop-Widget-#{version}-linux-x86_64.AppImage",
      verified: "github.com/Robertg761/HA-Desktop-Widget/"
  version "3.8.0"
  sha256 "39ae81fbadd9527ac75c5d82ba377943ff38ae550da0a1e623b455b0a348a559"

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
