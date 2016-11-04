class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "http://www.tcpdump.org/"
  url "http://www.tcpdump.org/release/tcpdump-4.8.1.tar.gz"
  sha256 "20e4341ec48fcf72abcae312ea913e6ba6b958617b2f3fb496d51f0ae88d831c"

  head "https://github.com/the-tcpdump-group/tcpdump.git"

  bottle do
    cellar :any
    sha256 "4fbafd97a2ffe6c1f1ff61031d091640b780e80c5c046c17501ec4b69592da7f" => :sierra
    sha256 "b75c77843c928ea74e8dee47a32c80d35692636273177b954574c5b5308ec12b" => :el_capitan
    sha256 "4155a44f6b36d432ba94e23391e1284bfb771dabbad6727020f188a62fb28c61" => :yosemite
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
