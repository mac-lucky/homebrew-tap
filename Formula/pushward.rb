class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "04ab915a9dc09f9448eaaf99162e2b091f89414a3c8b99d972f9df17e869bac5"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.8.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ede4fac26ef61d4eef8613c49652d044a01855d5a32f5107bad4154e78d3532a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "830c82c8d87c3aeab4c2704a5d4690e303c69717a6f24c097c2e4c2872edc4f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff93e99337453c12a234c138a39a125ebee5ad2bc5f29bee364193f1a97a16c0"
    sha256 cellar: :any,                 x86_64_linux:  "d549c69eac8e0756623bc5d3f56cdf0a2122f7f59c6cfb66fddfa5c9eedd47d7"
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
