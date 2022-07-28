class Openlens < Formula
  desc "Kubernetes IDE"
  homepage "https://github.com/lensapp/lens"
  url "https://github.com/lensapp/lens.git",
      tag:      "v6.0.0",
      revision: "9bc0e8951bbcfe153ac796fa661de2b4bc6a18ce"
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
    ENV.deparallelize
    # Don't dirty the git tree
    rm_rf ".brew_home"

    ENV["ELECTRON_BUILDER_EXTRA_ARGS"] = OS.mac? ? "--macos dir" : "--linux dir"
    system "make", "build"

    if OS.mac?
      dist_suffix = Hardware::CPU.intel? ? "" : "-#{Hardware::CPU.arch}"

      prefix.install "dist/mac#{dist_suffix}/OpenLens.app"
      bin.write_exec_script prefix/"OpenLens.app/Contents/MacOS/OpenLens"
    else
      prefix.install Dir["dist/linux-unpacked/*"]
      bin.write_exec_script prefix/"open-lens"
    end
  end

  def caveats
    if OS.mac?
      <<~EOS
        To start OpenLens, from a terminal run
        "#{prefix}/OpenLens.app/Contents/MacOS/OpenLens".

        Alternatively, run
        ln -sfn "#{prefix}/OpenLens.app" /Applications/OpenLens.app
        to start OpenLens from Spotlight or Finder.
      EOS
    end
  end

  test do
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.mac?
      install_path = prefix/"OpenLens.app/Contents/"
      assert_predicate install_path/"MacOS/OpenLens", :executable?
      assert_predicate install_path/"Resources/#{arch}/lens-k8s-proxy", :executable?
      assert_predicate install_path/"Resources/#{arch}/kubectl", :executable?
      assert_predicate install_path/"Resources/#{arch}/helm", :executable?
    else
      assert_predicate prefix/"open-lens", :executable?
      assert_predicate prefix/"resources/#{arch}/lens-k8s-proxy", :executable?
      assert_predicate prefix/"resources/#{arch}/kubectl", :executable?
      assert_predicate prefix/"resources/#{arch}/helm", :executable?
    end
  end
end
