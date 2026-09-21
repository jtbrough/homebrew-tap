cask "konsole-unstable" do
  version "5324"
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

  postflight_steps do
    run "xattr",
        args:         ["-r", "-d", "com.apple.quarantine", "{{appdir}}/Konsole.app"],
        must_succeed: false

    # Upstream bug: src/CMakeLists.txt calls ecm_add_app_icon(ICONS_SOURCES ...)
    # but never adds ${ICONS_SOURCES} to add_executable(konsole ...), so the
    # generated .icns is built and then never copied into the app bundle, even
    # though Info.plist's CFBundleIconFile still points at it. Result: every
    # macOS CI build ships with a blank/generic app icon.
    # Upstream fix pending: https://invent.kde.org/utilities/konsole (MR TBD)
    #
    # postflight_steps can't reference a file bundled locally in this tap
    # (its DSL only accepts literal arguments), so the prebuilt icon is
    # fetched from this same tap's own repo instead.
    run "/usr/bin/curl",
        args:           [
          "-fsSL", "-o", "{{appdir}}/Konsole.app/Contents/Resources/ICONS_SOURCES.icns",
          "https://raw.githubusercontent.com/jtbrough/homebrew-tap/main/Casks/resources/konsole.icns"
        ],
        network_access: true,
        must_succeed:   false

    # Adding a resource invalidates the bundle's seal. The upstream build is
    # signed with a KDE Developer ID but is NOT notarized (spctl already
    # rejects it, which is why quarantine is stripped above), so ad-hoc
    # re-signing loses nothing Gatekeeper was honoring. It's required, though:
    # Apple Silicon refuses to launch an app with an invalid signature.
    #
    # Must be --deep: re-signing only the outer bundle leaves nested
    # frameworks (e.g. libkonsoleapp.dylib) signed with KDE's real Team ID
    # while the main executable becomes ad-hoc (no Team ID). --options
    # runtime re-enables the hardened runtime's Library Validation, which
    # then refuses to load those mismatched-Team-ID frameworks and the app
    # fails to launch ("Konsole cannot be opened..."). Dropping --options
    # runtime avoids that check entirely; --deep keeps every nested binary's
    # signature consistently ad-hoc so nothing mismatches.
    run "/usr/bin/codesign",
        args:         ["--force", "--deep", "--sign", "-", "{{appdir}}/Konsole.app"],
        must_succeed: false
  end

  zap trash: [
    "~/.config/konsolerc",
    "~/.local/share/konsole",
    "~/Library/Application Support/konsole",
    "~/Library/Preferences/konsolerc",
  ]
end
