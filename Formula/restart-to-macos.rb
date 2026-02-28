# typed: false
# frozen_string_literal: true

class RestartToMacos < Formula
  desc "Simple CLI and desktop launcher for one-time restart into macOS on Asahi Linux"
  homepage "https://github.com/jtbrough/restart-to-macos"
  url "https://github.com/jtbrough/restart-to-macos/releases/download/v0.1.2/restart-to-macos-0.1.2.tar.gz"
  sha256 "f67c5b45c63fd009d5122dd03ed9f8b552ee786a27da121ee5979ff03eead654"
  license "MIT"

  depends_on :linux

  def install
    system "./install.sh", "--prefix", prefix, "--package-build", "--no-polkit"
    inreplace share/"applications"/"restart-to-macos.desktop",
      /^Exec=.*/,
      "Exec=#{opt_bin}/restart-to-macos"
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
