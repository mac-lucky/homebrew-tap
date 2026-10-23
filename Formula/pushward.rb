class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "62bfaff85a00454bb60ad03012f47a127cead83776fdf38931792e3241d8bdb1"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.5.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f72a8ccfa31dff562d2c06929662ede039936bd126603a9065827f9b4cd516fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e227bfeda9f64cc24f0163986924a39d539ef31c0eee09595a7349447ac99703"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f08796eb0759c595292146153f9f482b3b3c29bcfc4176f1f9d6e666fc0b0e2"
    sha256 cellar: :any,                 x86_64_linux:  "175bc223439e0443de165259e93b969155f7b17536ec4a32a38d2fb0eacf51b3"
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
