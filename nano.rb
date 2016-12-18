class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.7/nano-2.7.2.tar.gz"
  sha256 "89cc45dd630c6fb7276a14e1b3436a9972cf6d66eed15b14c3583af99070353c"

  bottle do
    sha256 "8d9d85b9539a87c5f1096d1471a97e39278df4011ecd0afcb93fd0a189102798" => :sierra
    sha256 "9b213f9000d7c0a12b882284f07c2fc12cfb5a4a2bea8978468919103c6db9b6" => :el_capitan
    sha256 "f244edd839dbc8556fef5b784f1827e7575aecad43ba0a6098ec375cbf3410cd" => :yosemite
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
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
