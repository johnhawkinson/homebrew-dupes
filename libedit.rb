class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "http://thrysoee.dk/editline/"
  url "http://thrysoee.dk/editline/libedit-20160903-3.1.tar.gz"
  version "20160903-3.1"
  sha256 "0ccbd2e7d46097f136fcb1aaa0d5bc24e23bb73f57d25bee5a852a683eaa7567"

  bottle do
    cellar :any
    revision 1
    sha256 "8f5ab51b9dd30aa49911394e2d7f504b998aa4c896919cbd988c82037db3657c" => :el_capitan
    sha256 "3e87dcba616bf44421601e18852f207cddbca9abc66a7b5c18e2fb8133d2d8de" => :yosemite
    sha256 "144a566802d42825d9371d518ece15587d6b439fefdcc12adbd989d141372055" => :mavericks
  end

  keg_only :provided_by_osx

  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-widec",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
