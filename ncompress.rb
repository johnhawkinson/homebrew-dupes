class Ncompress < Formula
  desc "Fast, simple LZW file compressor"
  homepage "https://github.com/vapier/ncompress"
  url "https://github.com/vapier/ncompress/archive/v4.2.4.4.tar.gz"
  sha256 "2670439935e7639c3a767087da99810e45bc3997d0638b3094396043571e5aec"
  head "https://github.com/vapier/ncompress"

  keg_only :provided_by_osx

  def install
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    Pathname.new("hello").write "Hello, world!"
    system "#{bin}/compress", "-f", "hello"
    assert_match "Hello, world!", shell_output("#{bin}/compress -cd hello.Z")
  end
end
