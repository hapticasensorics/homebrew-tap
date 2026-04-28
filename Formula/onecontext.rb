class Onecontext < Formula
  desc "1Context passively captures what you work on, builds a living wiki for every project you touch, updates as you work, and opens in any browser with a shareable link. Claude Code and Codex connect via MCP. No configuration, no prompts, no workflow changes."
  homepage "https://haptica.ai"
  url "https://github.com/hapticasensorics/1context/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "59fadc1fcef8b19b5e3d0332f6c292aaef2d5f866244a524336c93d4336c5c97"
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
