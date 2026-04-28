class Onecontext < Formula
  desc "1Context passively captures what you work on, builds a living wiki for every project you touch, updates as you work, and opens in any browser with a shareable link. Claude Code and Codex connect via MCP. No configuration, no prompts, no workflow changes."
  homepage "https://haptica.ai"
  url "https://github.com/hapticasensorics/1context/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "f1f370c8fb40b0fb7c0a1989fa15a10b4f66125c7ceda663aeeba7805b135c16"
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
