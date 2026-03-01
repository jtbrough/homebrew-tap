# typed: false
# frozen_string_literal: true

class RestartToMacos < Formula
  desc "Simple CLI and desktop launcher for one-time restart into macOS on Asahi Linux"
  homepage "https://github.com/jtbrough/restart-to-macos"
  url "https://github.com/jtbrough/restart-to-macos/releases/download/v0.1.4/restart-to-macos-0.1.4.tar.gz"
  sha256 "ad5af7a8c198d425be1f7518edc25ed29f67651193e27d21f7700ccdbb66937c"
  license "MIT"

  depends_on :linux

  def install
    system "./install.sh", "--prefix", prefix, "--package-build", "--no-polkit"
    inreplace share/"applications"/"restart-to-macos.desktop",
      /^Exec=.*/,
      "Exec=#{opt_bin}/restart-to-macos"
  end

  def post_install
    applications_dir = Pathname.new(ENV.fetch("HOME")).join(".local", "share", "applications")
    desktop_source = opt_share/"applications"/"restart-to-macos.desktop"
    desktop_target = applications_dir/"restart-to-macos.desktop"

    applications_dir.mkpath

    return if desktop_target.exist? && !desktop_target.symlink?

    if desktop_target.symlink?
      begin
        return if desktop_target.realpath == desktop_source.realpath
      rescue Errno::ENOENT
        nil
      end
      desktop_target.delete
    end

    desktop_target.make_symlink(desktop_source)
  end

  def uninstall
    desktop_source = opt_share/"applications"/"restart-to-macos.desktop"
    desktop_target = Pathname.new(ENV.fetch("HOME")).join(".local", "share", "applications", "restart-to-macos.desktop")

    return unless desktop_target.symlink?

    begin
      desktop_target.delete if desktop_target.realpath == desktop_source.realpath
    rescue Errno::ENOENT
      desktop_target.delete if desktop_target.readlink == desktop_source
    end
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
