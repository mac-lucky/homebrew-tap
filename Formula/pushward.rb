class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v0.1.0-rc.1.tar.gz"
  sha256 "344737693b04f126a28db669c8b5bb915a5d924410461a80b1c8443534bf3f9b"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-0.1.0-rc.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "19a1504706b326b66e1ab7eee27cca5ddc7b65e415e68e232d93b65abb2ddd4b"
    sha256 cellar: :any,                 x86_64_linux: "68be8c65ee766f3730f49b6e2628c1b0f2810e021918252d2cc9cf09b595d1d5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pushward"
    generate_completions_from_executable(bin/"pushward", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pushward version")
    # With no key configured it must fail before any network call.
    assert_match "no API key", shell_output("#{bin}/pushward me 2>&1", 3)
  end
end
