class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "62bfaff85a00454bb60ad03012f47a127cead83776fdf38931792e3241d8bdb1"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.6.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f57ecd8d8ae3534b3046da9d298ef4810e8f4c5fb960c409eaeaf0dfbaca5490"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bda362c6eda89f497688c4294c7546373ce2284cf8b097768d1e3f7b24758019"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e2eef61a929cdb7557230ccd8d98fe87c4950c0f95a36e1e4f62b13905c88be"
    sha256 cellar: :any,                 x86_64_linux:  "4129ab5be0f35431123a28dc96a984ed9283c243db6b2eb3f729b3e2e66a99b9"
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
