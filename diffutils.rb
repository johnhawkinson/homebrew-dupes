class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/s/diffutils/"
  url "https://ftpmirror.gnu.org/diffutils/diffutils-3.5.tar.xz"
  mirror "https://ftp.gnu.org/gnu/diffutils/diffutils-3.5.tar.xz"
  sha256 "dad398ccd5b9faca6b0ab219a036453f62a602a56203ac659b43e889bec35533"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2af9d67fe5a44685015724fe373503abc38e63646104c05cc6833fd89d5b2ddf" => :el_capitan
    sha256 "d58ffc234a2bc8664313d1d85dd5e30253e9a6dbbd22617ac0a028e777995d63" => :yosemite
    sha256 "1c0778fa87cd4905dd7e0f418c7f98e183f7dd558e90115ea5d1d505de10c7a2" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"diff", "a", "b"
  end
end
