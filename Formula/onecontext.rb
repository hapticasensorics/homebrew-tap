class Onecontext < Formula
  desc "1Context passively captures what you work on, builds a living wiki for every project you touch, updates as you work, and opens in any browser with a shareable link. Claude Code and Codex connect via MCP. No configuration, no prompts, no workflow changes."
  homepage "https://haptica.ai"
  url "https://github.com/hapticasensorics/1context/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2f28b0ac9e99ea8d24c568a19a0375662f3bea2575c4f771ddb3ae298de2aec4"
  license "Apache-2.0"

  depends_on "node"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/1context.js" => "1context"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/1context --version")
    assert_match "CLI installed", shell_output("#{bin}/1context doctor")
    assert_match "No directories were created", shell_output("#{bin}/1context paths")
  end
end
