class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://mirrors.kernel.org/debian/pool/main/w/whois/whois_5.2.14.tar.xz"
  sha256 "a41daf41abed0fbfa8c9c4b0e4a3f5f22d9876dd6feb9091aac12f8f4c38b0d2"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e4ff8bd1007cbc3b435ad6041d6035e728b3c03ff2551a820b78932f48ed559" => :sierra
    sha256 "e2e1559623fe6e6daf3ed529010e0702653ddaf9ce6063eedf18b1fd6a44624a" => :el_capitan
    sha256 "8a6b242fb31b9aa9bd8b8bea66ea09c50ae4b288f8b8d119214e3abc17b5a4e5" => :yosemite
  end

  def install
    # autodie was not shipped with the system perl 5.8
    inreplace "make_version_h.pl", "use autodie;", "" if MacOS.version < :snow_leopard

    args = []
    args << "HAVE_ICONV=1" << "whois_LDADD+=-liconv" if OS.mac?
    system "make", "whois", *args
    bin.install "whois"
    man1.install "whois.1"
  end

  def caveats; <<-EOS.undent
    Debian whois has been installed as `whois` and may shadow the
    system binary of the same name.
    EOS
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end
