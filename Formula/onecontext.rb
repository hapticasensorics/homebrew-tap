class Onecontext < Formula
  desc "1Context passively captures what you work on, builds a living wiki for every project you touch, updates as you work, and opens in any browser with a shareable link. Claude Code and Codex connect via MCP. No configuration, no prompts, no workflow changes."
  homepage "https://haptica.ai"
  url "https://github.com/hapticasensorics/1context/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "0fc7c142d286a28ba19ee32fe58e092e53317c1e4d8d50574294a6403f2aaa3a"
  license "Apache-2.0"

  depends_on "node"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/1context.js" => "1context"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/1context --version")
  end
end
