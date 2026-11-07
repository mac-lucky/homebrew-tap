class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "3a961311b04f87bb9fd38b11e1b95c61029d7c6438821f945a9b3abfceb98337"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.11.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58e338d89f3f3d188a52071f35a06fe1d12cc379d62af796a2f852b85ef830e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cb9e4baadf6f40f28bd319f05405f778dd9621fcf4ae2abdcffc2f9e784706e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1162d30d8d535ac9a4b025612e1af501b797cdc3fe1a0b91ee4ce1fddc1541b9"
    sha256 cellar: :any,                 x86_64_linux:  "9e8d75e77b5c8e5de7eb431e6c4ca0e79b25506bce25d323780668ec1c6abebe"
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
