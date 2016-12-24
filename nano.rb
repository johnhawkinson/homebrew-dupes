class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.7/nano-2.7.2.tar.gz"
  sha256 "89cc45dd630c6fb7276a14e1b3436a9972cf6d66eed15b14c3583af99070353c"
  revision 1

  bottle do
    sha256 "2d5c2af1c5c17ab7b45495fa7e50dbddc96d3cc689400b99bae8050911ee09aa" => :sierra
    sha256 "df772bc72cc5b9e0fb7516dc1e2be17f6a60b92e7cbfe30b810922b97d010ddc" => :el_capitan
    sha256 "c40b6a1b83e8b85210dd468d91c3e3cd770d1c9d9d0cfc59ed1cce399070994e" => :yosemite
  end

  head do
    url "http://git.savannah.gnu.org/r/nano.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "homebrew/dupes/ncurses"
  depends_on "libmagic" unless OS.mac?

  def install
    # Otherwise SIGWINCH will not be defined
    ENV.append_to_cflags "-U_XOPEN_SOURCE" if MacOS.version < :leopard

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/nanorc.sample"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
