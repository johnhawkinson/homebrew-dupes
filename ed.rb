class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftpmirror.gnu.org/ed/ed-1.14.1.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ed/ed-1.14.1.tar.lz"
  sha256 "ffb97eb8f2a2b5a71a9b97e3872adce953aa1b8958e04c5b7bf11d556f32552a"

  bottle do
    cellar :any_skip_relocation
    sha256 "69032b6b2162fb516472bb92505a7657b7645e6522ae8f251c7781402e82e104" => :sierra
    sha256 "3f0619432ac895107f603e6bbd14e8cc81e7431c7ba0a157d6aaf78f808fa6f7" => :el_capitan
    sha256 "3c2fcb97472eb5824e15cc993e318d20ce668adf5462686a466f5833ced8ae8f" => :yosemite
  end

  deprecated_option "default-names" => "with-default-names"
  option "with-default-names", "Don't prepend 'g' to the binaries"

  def install
    ENV.deparallelize

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
