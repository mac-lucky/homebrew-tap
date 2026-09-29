class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "e37c6d001a95c23408cc2a06bd9d5f1bbca69a71c2e57a112785e42002416ee5"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.0.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "eb378669e3d635c7c8dfe6fe02b2ba1ec39a3676dcc5207f0221eb04f67eda4f"
    sha256 cellar: :any,                 x86_64_linux: "00e24c62a4a357adcb079725f5f7bf6b42003113ef2fba481e5c02a1a365e5bb"
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
