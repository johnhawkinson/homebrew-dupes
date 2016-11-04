class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "http://www.tcpdump.org/"
  url "http://www.tcpdump.org/release/tcpdump-4.8.1.tar.gz"
  sha256 "20e4341ec48fcf72abcae312ea913e6ba6b958617b2f3fb496d51f0ae88d831c"

  head "https://github.com/the-tcpdump-group/tcpdump.git"

  bottle do
    cellar :any
    sha256 "b969788e892accce35c0e9e3bde1ad03d315eb53e8240ea995a1af5813505807" => :yosemite
    sha256 "55add2e80c88e70fd6af0b043f7366f106d4cbff8b41eb34bbf9f6078aefcf95" => :mavericks
    sha256 "67abede2a0c328caad072fdd7970580b3ba38e4a79b9eed61f2bd0e47c4b9ffb" => :mountain_lion
  end

  depends_on "openssl"

  if OS.mac?
    depends_on "homebrew/dupes/libpcap" => :optional
  else
    depends_on "homebrew/dupes/libpcap"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-ipv6",
                          "--disable-smb",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    system sbin/"tcpdump", "--help"
  end
end
