class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "38c9e1790ef57ff3e4351b525434e3d38d230094bb67ec5ea5a8387c180174c8"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.7.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f347f5b7e0448ded0ebf5b4d3ffee2712b83ea62e0b71dc4f801a86a45c95102"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff9a646b74444ec17d0b6ad05fc19669fea2d4aff4c1659ddd171f23cc61bbdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "813f064ea232ad3446198fb2077f100bd3961451ea88838568bed65524fd1314"
    sha256 cellar: :any,                 x86_64_linux:  "d7dcf22805ea57073b2d37ff57049edea264f6cf4cd8312baaf2343f17889a2e"
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
