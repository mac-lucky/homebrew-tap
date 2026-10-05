class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "592995575d1ed58582b3296cfc4310d73b1c0886846f39515eaf084c786b61fc"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f303cae2ce85f8f4b0d459ca8b92d09a831e529424f2dbb547b001bad9e2aa25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7febf655e6704dbd1c41ee7c091c6ec89b900817c69e59b135817ba2809e9349"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50c2ffd4b85b9f930fea9be7bd0632cc7ad03094f218f4f96feda6a839d71305"
    sha256 cellar: :any,                 x86_64_linux:  "3fea8890bfde2c71a47339ef0d718cb3c8e4c5edb262067c73aba451d1cb3b04"
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
