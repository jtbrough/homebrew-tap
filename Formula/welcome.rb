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

    # `post_install` (and its `post_install_steps` replacement) runs
    # under a hermetic sandbox with a fake $HOME on this Homebrew build,
    # so it can't reach the real ~/.config or ~/.local/share to shadow
    # the bootc-image-baked bootstrap copy. Instead, install a script
    # the user runs once themselves (real shell, real $HOME) - see
    # `kairpods-setup` in this same tap for the same workaround.
    setup_script = <<~BASH
      #!/bin/sh
      # Idempotent - re-run after every `brew upgrade welcome`.
      #
      # XDG user-level autostart/applications entries with the same
      # filename take precedence over the system ones at
      # /etc/xdg/autostart and /usr/share/applications, which live on
      # the (read-only) bootc image and can't be edited directly. This
      # is how the bootstrap copy stops being launched, without
      # touching /usr at all.
      set -eu
      mkdir -p "$HOME/.config/autostart" "$HOME/.local/share/applications"

      cat > "$HOME/.config/autostart/welcome.desktop" <<'DESKTOP'
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

      cat > "$HOME/.local/share/applications/welcome.desktop" <<'DESKTOP'
[Desktop Entry]
Type=Application
Name=Welcome
Comment=First-run/on-demand setup menu
Exec=#{bin}/welcome
Icon=preferences-desktop
Terminal=false
Categories=System;Settings;
DESKTOP

      echo "welcome: autostart/launcher entries now point at #{bin}/welcome"
    BASH
    (bin/"welcome-setup-autostart").write setup_script
    (bin/"welcome-setup-autostart").chmod(0755)
    File.write("/tmp/welcome_chmod_debug.txt",
               format("%o\n", (bin/"welcome-setup-autostart").stat.mode))
  end

  def caveats
    <<~EOS
      To shadow the bootc-image bootstrap copy so this brew-installed
      welcome is what actually runs (no image rebuild needed):
        welcome-setup-autostart
    EOS
  end

  test do
    assert_path_exists bin/"welcome"
    assert_path_exists bin/"welcome-setup-autostart"
    assert_path_exists share/"welcome/items.json"
  end
end
