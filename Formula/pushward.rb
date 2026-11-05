class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "b1621258a9198285a20baf1ccdbb5afca1230d8bd1bd82b1ac23fa9230e2f893"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.9.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa46caa067fc91375648a37cbf976df7dd4c5f10af021411e5b27dcbf6ec221a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69c5e53b6a509683bff6bfa315686ee27098fc5e981a3f676c2477732f5a5759"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d57fdbaa5efa92ed5c08ca4dc7f684362da7154242610e07c97bddb51a96ab0"
    sha256 cellar: :any,                 x86_64_linux:  "32711a028206e93d38032cd6cf2c153f0beeee20d052d80447d63e290149b1b9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pushward"
    generate_completions_from_executable(bin/"pushward", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pushward version")
    # With no key configured it exits 3 (auth) before any network call.
    shell_output("#{bin}/pushward me", 3)
  end
end
