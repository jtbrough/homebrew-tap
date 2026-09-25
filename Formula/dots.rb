class Dots < Formula
  desc "Declarative workstation, package, and dotfiles manager"
  homepage "https://git.home.brough.org/jordan/dots"
  url "https://git.home.brough.org/jordan/dots/releases/download/v0.1.1/dots-v0.1.1-x86_64-unknown-linux-gnu.tar.gz"
  sha256 "54a71590b2c61bb6b68104580a71bf350d93a53ef03ba01d4cdf868a00add7ff"
  license "0BSD"

  depends_on arch: :x86_64
  depends_on :linux

  def install
    bin.install "dots"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dots --version")
  end
end
