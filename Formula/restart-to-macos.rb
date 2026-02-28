# typed: false
# frozen_string_literal: true

class RestartToMacos < Formula
  desc "Simple CLI and desktop launcher for one-time restart into macOS on Asahi Linux"
  homepage "https://github.com/jtbrough/restart-to-macos"
  url "https://github.com/jtbrough/restart-to-macos/releases/download/v0.1.1/restart-to-macos-0.1.1.tar.gz"
  sha256 "e50a1ae14ee49111c545897fb0140eb68dc1138e375288a5b0e82cabb988b596"
  license "MIT"

  depends_on :linux

  def install
    system "./install.sh", "--prefix", prefix, "--package-build", "--no-polkit"
  end

  def caveats
    <<~EOS
      restart-to-macos requires asahi-bless from your Linux distro.

      Fedora Asahi:
        sudo dnf install asahi-bless

      Arch/Asahi Arch:
        sudo pacman -S asahi-bless
    EOS
  end

  test do
    system "#{bin}/restart-to-macos", "--help"
  end
end
