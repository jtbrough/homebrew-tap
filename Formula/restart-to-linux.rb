class RestartToLinux < Formula
  desc "Restart macOS into Asahi Linux for one boot"
  homepage "https://github.com/jtbrough/restart-to-linux"
  url "https://github.com/jtbrough/restart-to-linux/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "5efb626f809e6c54fb264be05170db3178d2b3990c328bea6a0ef14f776fe156"
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
