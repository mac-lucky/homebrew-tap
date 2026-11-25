class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "3630623246d1756cabe67b204eaf639ab473ec16d897cda15195c47e8363ab04"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.16.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4bb4b3a5defae02716b1b491fc4e65a6014dc8695c9eadb5df196ff5a87156d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c58a68c62c5d15c20935873881685ba082b4aae2b78d924b51c3a8443b894b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6aca562fcb7018c3585edc0a96c8eaee31666826e61ae0886e5a452ce49377a"
    sha256 cellar: :any,                 x86_64_linux:  "842dea3f647a7e29ae4120bd4e433aa8a73d29651ea1ceb38333468050651dd7"
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
