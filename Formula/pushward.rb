class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "c04a6fe24f8248f6555d225c115a06b04930f1a08cf04303bf26532836ec7865"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.8.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d034c258c59e9d71c4f7ab651230c00168362486bf413cc7c279667d5aa46cc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c93b23be8ea44ffa9f7a19e930a394168b25f9e4e821547acac2153dc4747577"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11afae19d675ac9db131ee1af6d75a1efa7012d3af70157446714f4413918be6"
    sha256 cellar: :any,                 x86_64_linux:  "9d503b04376fd8a4d1039bab9951b58e0084136af295d51e383a2e9ac439eb0e"
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
