class Welcome < Formula
  desc "Declarative first-run/on-demand workstation setup menu"
  homepage "https://git.home.brough.org/jordan/welcome"
  url "https://git.home.brough.org/jordan/welcome/releases/download/v0.1.0/welcome-v0.1.0-src.tar.gz"
  sha256 "f3187340e68d5265a0969e3ae68815beb8f3a738a4bf4cbcd3f955e6840fff89"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on :linux
  depends_on "qtbase"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DWELCOME_SHARE_DIR=#{share}/welcome",
           *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/welcome"
    (share/"welcome").install "items.json"
  end

  # Shadows the bootc-image-baked bootstrap copy: XDG user-level
  # autostart/applications entries with the same filename take
  # precedence over the system ones at /etc/xdg/autostart and
  # /usr/share/applications, which live on the (read-only) bootc image
  # and can't be edited/removed directly. Re-written on every
  # install/upgrade so it always points at the current brew binary.
  def post_install
    autostart_dir = Pathname.new(Dir.home)/".config/autostart"
    apps_dir = Pathname.new(Dir.home)/".local/share/applications"
    autostart_dir.mkpath
    apps_dir.mkpath

    (autostart_dir/"welcome.desktop").write <<~DESKTOP
      [Desktop Entry]
      Type=Application
      Name=Welcome
      Comment=First-run/on-demand setup menu
      Exec=#{bin}/welcome --autostart
      Icon=preferences-desktop
      Terminal=false
      NoDisplay=true
      X-KDE-autostart-phase=1
    DESKTOP

    (apps_dir/"welcome.desktop").write <<~DESKTOP
      [Desktop Entry]
      Type=Application
      Name=Welcome
      Comment=First-run/on-demand setup menu
      Exec=#{bin}/welcome
      Icon=preferences-desktop
      Terminal=false
      Categories=System;Settings;
    DESKTOP
  end

  def caveats
    <<~EOS
      welcome's autostart/launcher entries now shadow the bootc-image
      bootstrap copy (~/.config/autostart, ~/.local/share/applications).
      No image rebuild needed for `brew upgrade welcome` to take effect.
    EOS
  end

  test do
    assert_path_exists bin/"welcome"
    assert_path_exists share/"welcome/items.json"
  end
end
