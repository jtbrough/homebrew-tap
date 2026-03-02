class RestartToLinux < Formula
  desc "Restart macOS into Asahi Linux for one boot"
  homepage "https://github.com/jtbrough/restart-to-linux"
  url "https://github.com/jtbrough/restart-to-linux/releases/download/v0.1.5/restart-to-linux-0.1.5.tar.gz"
  sha256 "607d98b0b1ebb5fc48a7aa062d3d1f6cd141e68de93ad9d3117196212b8636b8"
  license "MIT"

  depends_on :macos

  def install
    bin.install "src/bin/restart-to-linux"
    (share/"restart-to-linux/libexec").install "src/libexec/restart-to-linux-common"
    (share/"restart-to-linux").install "VERSION"
    (share/"restart-to-linux").install "src/applescript/restart-to-linux.applescript" => "restart-to-linux.applescript"
    (share/"restart-to-linux").install "src/applescript/restart-to-linux-launcher.applescript" => "restart-to-linux-launcher.applescript"
    (share/"restart-to-linux").install "src/macos/restart-to-linux-launcher.sh" => "restart-to-linux-launcher.sh"
    (share/"restart-to-linux").install "packaging/macos/AsahiLinux.icns" if File.exist?("packaging/macos/AsahiLinux.icns")
  end

  def caveats
    <<~EOS
      To install the Finder/Spotlight app in ~/Applications:
        restart-to-linux --install-app
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/restart-to-linux --version")
  end
end
