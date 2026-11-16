class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "0fa55c48524d8c32217322a9d8a5ddf2a3d7b1a76313e37c2403214f2e32eb38"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.13.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ccde61deafed7cdc700c48cb31b9f95a3849e7f04943b13dad4bd51339bec37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8de8810ad07d54e4cd5c51138eefa00d24fe9b1f89240c6357cb1c966f32c7c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18968cb21d0f65d6f7eedf187bd16fe5f3d198e80d1fc7008c141bb1319779fb"
    sha256 cellar: :any,                 x86_64_linux:  "9db279e1550daaa23c64201fcaeda7c861218aabd212eb3f6c90160c453da3ad"
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
