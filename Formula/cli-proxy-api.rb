class CliProxyApi < Formula
  desc "Proxy server providing OpenAI/Gemini/Claude/Codex compatible APIs"
  homepage "https://github.com/hrygo/CLIProxyAPI"
  # Declared explicitly rather than derived from the URL. Release tags carry an
  # -upstreamX.Y.Z suffix, and Homebrew's URL-derived version parsing is not
  # reliable for that shape.
  version "1.0.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/hrygo/CLIProxyAPI/releases/download/v1.0.1-upstream8.0.5/CLIProxyAPI_1.0.1_darwin_aarch64.tar.gz"
      sha256 "020e1711c76e5d85b392d45213ad688347d13e67dfe5e21d4ad6e08f56c0d6f6"
    else
      url "https://github.com/hrygo/CLIProxyAPI/releases/download/v1.0.1-upstream8.0.5/CLIProxyAPI_1.0.1_darwin_amd64.tar.gz"
      sha256 "4eb80feaa90cc9d247dfea7d8d0df57ea0f86ae895d76ea2b8000c323afc7fd7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/hrygo/CLIProxyAPI/releases/download/v1.0.1-upstream8.0.5/CLIProxyAPI_1.0.1_linux_aarch64.tar.gz"
      sha256 "b497c8a63272bc7afd15c21b3553491d6b4c3b217fc9fe5ed44213e2ebd64f34"
    else
      url "https://github.com/hrygo/CLIProxyAPI/releases/download/v1.0.1-upstream8.0.5/CLIProxyAPI_1.0.1_linux_amd64.tar.gz"
      sha256 "4a8329df1c91ac3ce2f1776a963489330358db778915fb1067429ba48c54b07a"
    end
  end

  def install
    # The upstream release archive names the binary cli-proxy-api. Install it
    # as cliproxyapi so the existing launchd agent path keeps working.
    bin.install "cli-proxy-api" => "cliproxyapi"
    pkgshare.install "config.example.yaml"
  end

  def caveats
    <<~EOS
      Configuration is not managed by Homebrew. Pass your own config path:
        cliproxyapi -config #{etc}/cliproxyapi.conf

      Upgrading changes the installed binary. Restart your service manager
      separately to load it. For the existing macOS LaunchAgent:
        launchctl kickstart -k gui/$(id -u)/com.hrygo.cliproxyapi
    EOS
  end

  test do
    output = shell_output("#{bin}/cliproxyapi -h 2>&1")
    assert_match "CLIProxyAPI Version:", output
    assert_match version.to_s, output
  end
end
