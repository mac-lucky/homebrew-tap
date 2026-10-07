class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "484ef0c164555aa858db14ed9e08d670bf3afbc94ca5a454087883ac67a091e7"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.4.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43efb1041564e10bfa075e166a94b351fe8c832115540e0b1569fe65d37a3882"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "182fea548802c45bf6006ef3afeb012ef4ee341e2966e6b9632fe66768b49fe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a37e2b5f60510df4d710cfa101f343cd2df7f4276f285aeab100846b3194f24"
    sha256 cellar: :any,                 x86_64_linux:  "c0a9898753080aa28fd86dcfeaa04098fb5ad3b238b5a4424ce4cfe511631d0c"
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
