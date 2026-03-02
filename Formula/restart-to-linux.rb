class RestartToLinux < Formula
  desc "Restart macOS into Asahi Linux for one boot"
  homepage "https://github.com/jtbrough/restart-to-linux"
  url "https://github.com/jtbrough/restart-to-linux/releases/download/v0.1.1/restart-to-linux-0.1.1.tar.gz"
  sha256 "ac0f98c614b4e5a40378b8b8c06a86ccb7f1370222742df7efdd9fc0344dd1cc"
  license "MIT"

  depends_on :macos

  def install
    bin.install "src/bin/restart-to-linux"
    (share/"restart-to-linux/libexec").install "src/libexec/restart-to-linux-common"
    (share/"restart-to-linux").install "VERSION"
    (share/"restart-to-linux").install "src/applescript/restart-to-linux.applescript" => "restart-to-linux.applescript"
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
