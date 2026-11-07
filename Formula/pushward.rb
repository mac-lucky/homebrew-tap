class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "3a961311b04f87bb9fd38b11e1b95c61029d7c6438821f945a9b3abfceb98337"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.11.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4492c6b59a1975f94917aa7dda17e1c4232c9aa233fbba26e99c57651ef82cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "659ef680a1606b9da08ae183ae809b5c6b534f0325e9b5e95dc1ce778f4c220d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a95480b1bd76ec516ac1b0de435a09769a5e6f753692f002d8ab4d4a8bdc794"
    sha256 cellar: :any,                 x86_64_linux:  "e51139347f18dfaee642577cdafff56f9cbc03884500d87f44127cc73eb280fe"
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
