class Onecontext < Formula
  desc "Own your context. An engine for agentic work."
  homepage "https://github.com/hapticasensorics/1context"
  url "https://github.com/hapticasensorics/1context/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1ed1e2c55a4011e0764c7dad538ac739b80a960a598505695d444bd553ac666b"
  license "Apache-2.0"

  def install
    bin.install "bin/1context"
  end

  test do
    assert_match "1context 0.1.0", shell_output("#{bin}/1context --version")
    assert_match "1Context plumbing ok", shell_output("#{bin}/1context doctor")
  end
end
