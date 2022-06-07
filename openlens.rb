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

    system "make", "build"
    if OS.mac?
      prefix.install "dist/mac/OpenLens.app"
      bin.write_exec_script prefix/"OpenLens.app/Contents/MacOS/OpenLens" if OS.mac?
    end
  end

  test do
    assert_path_exists prefix/"OpenLens.app/Contents/MacOS/OpenLens" if OS.mac?
  end
end
