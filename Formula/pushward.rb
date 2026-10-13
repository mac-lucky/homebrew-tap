class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "e9e3a01c59be403c6758e55a1ac8b0204f16e2f1be43eb2bf419248e0aeb04dd"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.5.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbf77a03d7e5a1384c7cb2ed3b79ce538627fe9611bae073d954a7c9138826eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b95fcbecff3771f28ad0073563b77a574c6603f064ee84a9de7dd7e021aa9b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2c629577f6e4d66053d81fbe3b695d5f65554a1fb8a303d7308e3c999a5cf2b"
    sha256 cellar: :any,                 x86_64_linux:  "b7a6ec228eadff40e4024584560c99365892dae89d988d36256559488e68e322"
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
