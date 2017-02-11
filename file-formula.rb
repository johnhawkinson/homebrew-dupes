# "File" is a reserved class name
class FileFormula < Formula
  desc "Utility to determine file types"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.30.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.30.tar.gz"
  sha256 "694c2432e5240187524c9e7cf1ec6acc77b47a0e19554d34c14773e43dbbf214"
  head "https://github.com/file/file.git"

  bottle do
    cellar :any
    sha256 "6f11492cf5eb0573171f1fa3d320705480f6338069273def97ac2addd0e1ebc9" => :sierra
    sha256 "9af23bd3192eb045f5281ff184127a13aec4090f1fe4a6f2e31d5587460231c6" => :el_capitan
    sha256 "f536aeb65fe9b37c0ee30ec2d7329dc071b9f9549d6b7ffd9fbf68a0dc636d5c" => :yosemite
  end

  keg_only :provided_by_osx

  depends_on "libmagic"

  patch :DATA

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["libmagic"].opt_lib} -lmagic"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install-exec"
    system "make", "-C", "doc", "install-man1"
    rm_r lib
  end

  test do
    system "#{bin}/file", test_fixtures("test.mp3")
  end
end

__END__
diff --git a/src/Makefile.in b/src/Makefile.in
index b6eeb20..4a7ae91 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -150,7 +150,6 @@ libmagic_la_LINK = $(LIBTOOL) $(AM_V_lt) --tag=CC $(AM_LIBTOOLFLAGS) \
 PROGRAMS = $(bin_PROGRAMS)
 am_file_OBJECTS = file.$(OBJEXT)
 file_OBJECTS = $(am_file_OBJECTS)
-file_DEPENDENCIES = libmagic.la
 AM_V_P = $(am__v_P_@AM_V@)
 am__v_P_ = $(am__v_P_@AM_DEFAULT_V@)
 am__v_P_0 = false
@@ -352,7 +351,7 @@ libmagic_la_LDFLAGS = -no-undefined -version-info 1:0:0
 @MINGW_TRUE@MINGWLIBS = -lgnurx -lshlwapi
 libmagic_la_LIBADD = $(LTLIBOBJS) $(MINGWLIBS)
 file_SOURCES = file.c
-file_LDADD = libmagic.la
+file_LDADD = $(LDADD)
 CLEANFILES = magic.h
 EXTRA_DIST = magic.h.in
 HDR = $(top_srcdir)/src/magic.h.in
