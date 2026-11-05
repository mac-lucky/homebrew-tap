class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "e172d826c86279ed79152553dc541a47a7fcdbb317d0f7be7afd2991073799e7"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.10.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1396f760818f66599b476ca6cf9f1a80b95b6011b0f0733ebe7db6541515c93d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e630c81cf794f3870d4c3ad701428f82dd319b91d822a2a9e0bcd06c0610ec9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2651cbd84a1a2cc755316911f13de279058bc816690e910876b2b8f9920048f0"
    sha256 cellar: :any,                 x86_64_linux:  "6131677a52b1961b02853dd8ce613bc8d6b433c9065cec99f46248c868814282"
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
