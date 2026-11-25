class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "3630623246d1756cabe67b204eaf639ab473ec16d897cda15195c47e8363ab04"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.15.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "983b25b5860aa035dc701088d915c90185f3a67563a67b676805b5cd644f3022"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14effbab73e2eb8e81141de6ba0824ec68d963e9d564c224fe03552f213210f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeab6644b9a24b1a505c5175903f0e545885af93a8452dd2b70b7a867345cad4"
    sha256 cellar: :any,                 x86_64_linux:  "fb991abc002d2a050b892892a87428adca08033875bd79a132baeafcf2edd0d5"
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
