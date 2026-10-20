class HaDesktopWidget < Formula
  desc "Lightweight Home Assistant desktop widget (Rainmeter-style)"
  homepage "https://github.com/Robertg761/HA-Desktop-Widget"
  url "https://github.com/Robertg761/HA-Desktop-Widget/releases/download/v#{version}/HA-Desktop-Widget-#{version}-linux-x86_64.AppImage",
      verified: "github.com/Robertg761/HA-Desktop-Widget/"
  version "4.0.0"
  sha256 "aa673c5376c9d73cab574a24e29a45d05a1b75ceb9f4193498d5a5d699cd391a"

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
