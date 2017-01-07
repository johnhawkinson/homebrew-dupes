class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://mirrors.kernel.org/debian/pool/main/w/whois/whois_5.2.14.tar.xz"
  sha256 "a41daf41abed0fbfa8c9c4b0e4a3f5f22d9876dd6feb9091aac12f8f4c38b0d2"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cf97ab9df095c8ed72586053460554974163ef012209bad7ada9bd0c0e7307c" => :sierra
    sha256 "8d1d245e1d9fbc29fafb24d946b79a7ec89cce8a9756a2bb58c4eb018c75dfbe" => :el_capitan
    sha256 "3e4f73d1248423b856ec7f7130dc1136de8cfce198bd0743722e859b10e94e2a" => :yosemite
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
