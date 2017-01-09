class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftpmirror.gnu.org/ed/ed-1.14.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ed/ed-1.14.tar.lz"
  sha256 "b948fe3d0d5f5c1ae944c0a9f2f57be99711d7eb3ffabaa18e7278b995acf136"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c2dfbddf78163b2f8bb640a6f2d7e9e94f0b04a1da51ed21e368ea0bb5b6909" => :sierra
    sha256 "09f1cdea1b61b6af7c943b05bcccadf0c395771489a34aa01fa93b56949f5e7a" => :el_capitan
    sha256 "29fec3a1fd32db0a4ee8bff01ac19fde1adc3abd48ddb63092317eae8baa5f96" => :yosemite
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
