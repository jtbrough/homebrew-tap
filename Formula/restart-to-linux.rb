class RestartToLinux < Formula
  desc "Restart macOS into Asahi Linux for one boot"
  homepage "https://github.com/jtbrough/restart-to-linux"
  url "https://github.com/jtbrough/restart-to-linux/releases/download/v0.1.3/restart-to-linux-0.1.3.tar.gz"
  sha256 "774e3be2128a253f9071813da747c55d9c0ea9ea949c66ee607fbc1bd71be0a4"
  license "MIT"

  depends_on :macos

  def install
    bin.install "src/bin/restart-to-linux"
    (share/"restart-to-linux/libexec").install "src/libexec/restart-to-linux-common"
    (share/"restart-to-linux").install "VERSION"
    (share/"restart-to-linux").install "src/applescript/restart-to-linux.applescript" => "restart-to-linux.applescript"
    (share/"restart-to-linux").install "src/applescript/restart-to-linux-launcher.applescript" => "restart-to-linux-launcher.applescript"
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
