class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "0fa55c48524d8c32217322a9d8a5ddf2a3d7b1a76313e37c2403214f2e32eb38"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.14.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01793494cca66cd6dcb1ff5bb7a0f91afde458c94b7d57daa3a20ba6815772f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a3cf8dce1e6d27b77f00c93a0eace2d461657987c2032e8a31d5bf7e7ca4f67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0454d58e87718fc93b867176414d369e74ad894ba397fd24b86261f647c2263b"
    sha256 cellar: :any,                 x86_64_linux:  "ce409aa332eca5afe35df0c1343e45deaa349f29d48b3a614163226b2d0c1dd0"
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
