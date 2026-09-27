class Welcome < Formula
  desc "Declarative first-run/on-demand workstation setup menu"
  homepage "https://git.home.brough.org/jordan/welcome"
  url "https://git.home.brough.org/jordan/welcome/releases/download/v0.1.4/welcome-v0.1.4-src.tar.gz"
  sha256 "da3557e5382028da3ce38b53f8713b4b92ddaab25b5fe798f9c440b2327d2166"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on :linux
  depends_on "qtbase"
  # Breeze (and most other icon themes) ship SVG icons; qtbase alone
  # has no SVG icon-engine plugin, so QIcon::fromTheme resolves the
  # file but silently renders a null icon without this (confirmed
  # empirically: isNull() flipped from true to false installing only
  # this one extra formula, no code change).
  depends_on "qtsvg"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DWELCOME_SHARE_DIR=#{share}/welcome",
           *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/welcome"
    (share/"welcome").install "items.json"
    (share/"welcome").install "jordan.png"
  end

  def caveats
    <<~EOS
      To shadow the bootc-image bootstrap copy so this brew-installed
      welcome is what actually runs (no image rebuild needed):
        welcome --setup-autostart

      Runs headless (no display needed) and writes user-level XDG
      autostart/launcher entries that take precedence over the
      image-baked ones. Re-run after every `brew upgrade welcome`.
    EOS
  end

  test do
    assert_path_exists bin/"welcome"
    assert_path_exists share/"welcome/items.json"
    assert_path_exists share/"welcome/jordan.png"
    system bin/"welcome", "--setup-autostart"
    assert_path_exists testpath/".config/autostart/welcome.desktop"
    assert_path_exists testpath/".local/share/applications/welcome.desktop"
  end
end
