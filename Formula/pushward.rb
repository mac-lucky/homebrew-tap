class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "5011c2804d6332375032d3344c2dc400e93464b4fa5d1b0742e5ea4d56816979"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.14.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f30645c7cfdc2eac4fec715e19db625c40d27784b4cfda6717962a7b1762408"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bdb6df34ca08ce4475d8c1ccdbabb128c9e37aaa1419d4ba08a5e2a568761af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f204bcd72a1a08c9705719f7c5282fabea2cbf4e36cfd56438ab94caf328553"
    sha256 cellar: :any,                 x86_64_linux:  "9a7e1b626ee62381fca24b728f216e4833bd427e3e41155c003343b213a1fe9f"
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
