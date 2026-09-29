class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "e37c6d001a95c23408cc2a06bd9d5f1bbca69a71c2e57a112785e42002416ee5"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.0.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b434dd3780145281b20d02f31d043f19345f2242afba8acb6c5b35ba9a9afc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdfbb841924cd35638337d876d69c86ba8be6b5d245858472b2cf621d4cec94b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc4c9f534aae0f653d33d277c288aedc80f6ab04fdca6efed43f7d52bd470514"
    sha256 cellar: :any,                 x86_64_linux:  "3c440d9e3f8829e42a75ed4a923310df51c148878ff0b1eac0f81e2f19da292e"
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
