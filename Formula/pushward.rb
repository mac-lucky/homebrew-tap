class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "e9e3a01c59be403c6758e55a1ac8b0204f16e2f1be43eb2bf419248e0aeb04dd"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.5.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5330d88e62ec4c6b4996d83668cf1b1e3948df1576e67c3d5111168b2818cb17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5085b5bdf4d2e4736773c7890f0cb2ba247efa91b61dd8dced64f1ccb2065ba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6105368fb015973fd3d5b0a691066d60eae948d56bbad3ab082cab691204c310"
    sha256 cellar: :any,                 x86_64_linux:  "5da038225a05621c0f635ffa79300635f17a6b352600e1840b2d9bd93dd993a0"
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
