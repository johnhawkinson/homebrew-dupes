class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftpmirror.gnu.org/ed/ed-1.14.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ed/ed-1.14.tar.lz"
  sha256 "b948fe3d0d5f5c1ae944c0a9f2f57be99711d7eb3ffabaa18e7278b995acf136"

  bottle do
    cellar :any_skip_relocation
    sha256 "b276749b82fc6469a4ca7172bf768b478e28d63ff56e6e4edc3447dddb6dc070" => :el_capitan
    sha256 "917a393cb31564765f482d19090199b24a7f1120f14d5943a47672680457bd19" => :yosemite
    sha256 "c61efe8a7243f76298205003952af63c4ec20593ff0d9c861dff2f947eaceb36" => :mavericks
  end

  deprecated_option "default-names" => "with-default-names"
  option "with-default-names", "Don't prepend 'g' to the binaries"

  def install
    ENV.j1

    args = ["--prefix=#{prefix}"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats
    if build.without? "default-names" then <<-EOS.undent
      The command has been installed with the prefix "g".
      If you do not want the prefix, reinstall using the "with-default-names" option.
      EOS
    end
  end

  test do
    testfile = testpath/"test"
    testfile.write "Hello world\n"
    cmd = build.with?("default-names") ? "ed" : "ged"
    pipe_output("#{bin}/#{cmd} -s #{testfile}", ",s/o//\nw\n", 0)
    assert_equal "Hell world\n", testfile.read
  end
end
