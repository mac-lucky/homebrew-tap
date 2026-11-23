class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "742bfb0bae0944ed051e9dfdbed490af19957c21887239f119246bc7f27b1d53"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.14.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a539ec08efb35585d86b8b7f852a3f2b5d146bc4740cf53ec48fd044af33b6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e783acbfcca9115e746a99377b66c5c746575e27965c7612389413c50a03fd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf3493e47792224b6ce036d7eef12aca180fe18b2e9cafcc4ddb13b4cf976b26"
    sha256 cellar: :any,                 x86_64_linux:  "a2f4d1c1872ed00cc7417d656e70769aaed4c1492582f93bf9afd1156daec796"
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
