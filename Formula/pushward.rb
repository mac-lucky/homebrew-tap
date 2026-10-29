class Pushward < Formula
  desc "Command-line client for PushWard notifications, Live Activities and widgets"
  homepage "https://github.com/mac-lucky/pushward-cli"
  url "https://github.com/mac-lucky/pushward-cli/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "2bc357266d2e96d437ddc6e3b29ecdb3c1204f0b5a0201a240f4dbeaa6baf61b"
  license "MIT"
  head "https://github.com/mac-lucky/pushward-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/mac-lucky/homebrew-tap/releases/download/pushward-1.7.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cca55121b5a92a474267b5212cb537abe67d544b815d2e2c2678d1bcf016b52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d895e4cc8b2dbbc3004919b4bec0ea45a5605344474960abdbb3b5c4a6c2f181"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fcdc8e3454d046e3fff7fbaf52c4342f0641349de025907e48e6da0347b2611"
    sha256 cellar: :any,                 x86_64_linux:  "97d2a8e75ea9d12352c460b3ab427c1423442289f64840640c9084f6cca8bdd5"
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
