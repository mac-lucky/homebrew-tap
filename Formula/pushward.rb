class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "d020a80384cb2fe254f7e44988a050c3bf2fcaae8c346ce00efd10cd80047a95"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.10.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d78f378673712b3fbdd3b8d622f375097b70fd08a54e326c1ce526aa47e6b7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d98171ba311d3ba28480760fe65b9e57f1ee6f93b5e3b5f674e179a5d9f56bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7bc61c5b61ffd2c0de85ad536c73ede86ccb99630e6b0bbaf76627bd4d3b305"
    sha256 cellar: :any,                 x86_64_linux:  "731ec52edb6729589ba59404de7d0c25798971c9088425fc86aeea94391c5fdf"
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
