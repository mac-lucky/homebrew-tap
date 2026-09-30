class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "1e1be983a0e7d711bc9a27bf6d277a8b2ec7e7bd3655d16f83489804b81fb9e0"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81e98953ee51f6d0859e433234e7ca903a8e6028d6a6126fafea5512acc0f69d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96de986709d0fdfde06f68437af0e1c2bde09a5ab9dbe27e077388f97d2c58eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0af83017f0e486208685cae69b35eb2beace62f5f206d8c58b4496b84e8fba5a"
    sha256 cellar: :any,                 x86_64_linux:  "a0b1245df8b21807e32c79e7e1027945f0c67bf72a77b598fdbed2a71c85abce"
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
