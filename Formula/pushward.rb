class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "a2781e45a5c897287be31378303cfff125fc2bb6cc8840672363efd47b7ce176"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.12.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0989f171907dc4689aaf40db2f4efd6d0ac87aa2c06bab68e7d1201642664a47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "006b513a245592115830024146598cd8e970a663c0550001d9e6847bfce6b4f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86534616c808515adeabcbc1fc025bb170ab2fa656b7e8a798b255653b42c7e1"
    sha256 cellar: :any,                 x86_64_linux:  "daf5f69e5dd768398340e1c33b1a7c029eabb2d676878ad20446960c5bf51e84"
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
