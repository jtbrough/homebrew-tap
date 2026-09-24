class Dots < Formula
  desc "Declarative workstation, package, and dotfiles manager"
  homepage "https://git.home.brough.org/jordan/dots"
  url "https://git.home.brough.org/jordan/dots/releases/download/v0.1.0/dots-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
  sha256 "cea6252b946c098db934bd8e63f1965e8fc4f32a9fc5bcb240784511e46d1b66"
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
