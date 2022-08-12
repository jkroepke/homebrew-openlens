cask "openlens" do
  arch arm: "-arm64"

  version "6.0.1"

  if Hardware::CPU.intel?
    sha256 "9ebd2a23cea45b4e862fd223dd74bab890a1b04181713da104801ecdc76c976f"
  else
    sha256 "39210a871c13775821090b560524e96a66443419b3441150ccb95ad1715ad357"
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
