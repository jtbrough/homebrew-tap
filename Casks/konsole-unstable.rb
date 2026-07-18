cask "konsole-unstable" do
  version "4981"
  sha256 :no_check

  on_arm do
    url "https://cdn.kde.org/ci-builds/utilities/konsole/master/macos-arm64/konsole-master-#{version}-macos-clang-arm64.dmg"
  end
  on_intel do
    url "https://cdn.kde.org/ci-builds/utilities/konsole/master/macos-x86_64/konsole-master-#{version}-macos-clang-x86_64.dmg"
  end

  name "Konsole Unstable"
  desc "KDE terminal emulator (unstable, built from master)"
  homepage "https://apps.kde.org/konsole/"

  livecheck do
    url "https://cdn.kde.org/ci-builds/utilities/konsole/master/macos-arm64/"
    regex(/konsole-master-(\d+)-macos-clang-arm64\.dmg/i)
  end

  depends_on :macos

  app "konsole.app", target: "Konsole.app"

  postflight do
    system_command "xattr",
                   args:         ["-r", "-d", "com.apple.quarantine", "#{appdir}/Konsole.app"],
                   must_succeed: false
  end

  zap trash: [
    "~/.config/konsolerc",
    "~/.local/share/konsole",
    "~/Library/Application Support/konsole",
    "~/Library/Preferences/konsolerc",
  ]
end
