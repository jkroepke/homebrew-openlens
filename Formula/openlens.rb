class Openlens < Formula
  desc "The Kubernetes IDE"
  homepage "https://github.com/lensapp/lens"
  url "https://github.com/lensapp/lens.git",
      tag:      "v5.5.3",
      revision: "09784e0324b6bfe9aec359a7e055c59ead3b697b"
  license "MIT"
  head "https://github.com/lensapp/lens.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "node@14" => :build
  depends_on "yarn" => :build
  uses_from_macos "unzip" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"
    ENV["ELECTRON_BUILDER_EXTRA_ARGS"] = OS.mac? ? "--macos dir" : "--linux dir"
    system "make", "build"

    if OS.mac?
      prefix.install "dist/mac/OpenLens.app"
      bin.write_exec_script prefix/"OpenLens.app/Contents/MacOS/OpenLens"
    else
      prefix.install "dist/linux/openlens"
    end
  end

  def caveats
    <<~EOS
      To start OpenLens, from a terminal run
      "#{prefix}/OpenLens.app/Contents/MacOS/OpenLens".

      Alternatively, run
      ln -sfn "#{prefix}/OpenLens.app" /Applications/OpenLens.app
      to start OpenLens from Spotlight or Finder.
    EOS
  end

  test do
    if OS.mac?
      assert_predicate prefix/"OpenLens.app/Contents/MacOS/OpenLens", :executable?
    else
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      #TODO: Linux test
    end
  end
end
