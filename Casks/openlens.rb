cask "openlens" do
  arch arm: "-arm64"

  version "6.1.1"

  if Hardware::CPU.intel?
    sha256 "aaf80c18832327858b10c75f133662debe303715908e49c899df99470a7acdb1"
  else
    sha256 "53f3f0ac70d2d24656c19eae78237a9696766afad023ef3319a29b7fe0800e8d"
  end

  url "https://github.com/MuhammedKalkan/OpenLens/releases/download/v#{version}/OpenLens-#{version}#{arch}.dmg"
  name "OpenLens"
  desc "Kubernetes IDE"
  homepage "https://github.com/MuhammedKalkan/OpenLens"

  auto_updates true

  app "OpenLens.app"

  zap trash: [
    "~/Library/Application Support/OpenLens",
    "~/Library/Logs/OpenLens",
    "~/Library/Caches/com.electron.kontena-lens",
    "~/Library/Preferences/com.electron.open-lens.plist",
    "~/Library/Saved Application State/com.electron.open-lens.savedState",
  ]
end
