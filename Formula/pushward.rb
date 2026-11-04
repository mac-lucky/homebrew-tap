class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "c04a6fe24f8248f6555d225c115a06b04930f1a08cf04303bf26532836ec7865"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.8.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c04304fc161cc50d7793d923674af4eb32a88e943237eb8c89a79410d793407"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0a16e9f4245077ee56809faf51ce20d36b53e3e606ef73d408d7751f758244f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f88fe325bc542605b841187341b3f7a6c188f28661fb1dfc089cea138d68ba88"
    sha256 cellar: :any,                 x86_64_linux:  "a862e47c0cd089548c7751305d858edc3807d3060e316186491951c4f4376516"
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
