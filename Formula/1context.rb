class Onecontext < Formula
  desc "1Context cross-agent memory plumbing"
  homepage "https://github.com/hapticasensorics/1context"
  url "https://github.com/hapticasensorics/1context/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "cbb5e9977bf0f6dbb30805ecf55490b0c257db1a27f18c8fb132a92a42e0a4c5"
  license "Apache-2.0"

  def install
    bin.install "bin/1context"
  end

  test do
    assert_match "1context 0.1.0", shell_output("#{bin}/1context --version")
    assert_match "1Context plumbing ok", shell_output("#{bin}/1context doctor")
  end
end
