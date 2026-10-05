class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "592995575d1ed58582b3296cfc4310d73b1c0886846f39515eaf084c786b61fc"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bca0cff546a7543abaff59f9e57736e3850117262cea49798848e9e4a02e68c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3648f8c4aa5b77d80250ae4bede8ed8b326a5289c4c3fcc28ad5f271999a4d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4355b511273e01b3ad68fb3950e0945ed7e14f1c5a851ba1d0c647813a1c3f8"
    sha256 cellar: :any,                 x86_64_linux:  "33cadeb105d0b6781086879534c01cd6e2fe03a78079fc1f04d27a846bcdb90d"
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
