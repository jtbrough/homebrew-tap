class HaDesktopWidget < Formula
  desc "Lightweight Home Assistant desktop widget (Rainmeter-style)"
  homepage "https://github.com/Robertg761/HA-Desktop-Widget"
  url "https://github.com/Robertg761/HA-Desktop-Widget/releases/download/v#{version}/HA-Desktop-Widget-#{version}-linux-x86_64.AppImage",
      verified: "github.com/Robertg761/HA-Desktop-Widget/"
  version "3.7.4"
  sha256 "699fc04b50f0872cc60cd59c45df5ee4ee0f1c8fa12818ff21cf807d64c308f9"

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
