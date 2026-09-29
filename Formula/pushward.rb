class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v0.1.0-rc.1.tar.gz"
  sha256 "344737693b04f126a28db669c8b5bb915a5d924410461a80b1c8443534bf3f9b"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

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
