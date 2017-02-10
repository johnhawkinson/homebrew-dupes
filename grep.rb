class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftpmirror.gnu.org/grep/grep-3.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/grep/grep-3.0.tar.xz"
  sha256 "e2c81db5056e3e8c5995f0bb5d0d0e1cad1f6f45c3b2fc77b6e81435aed48ab5"

  bottle do
    cellar :any
    sha256 "d90c8cecc613c3962a0b928150094b8e914ffb68e2cf5717407cdced73fa8f51" => :sierra
    sha256 "d61ef789cb13b20d7f22138bf926253613610efbe179b2942ad6b03ff4e20dfe" => :el_capitan
    sha256 "cd02270d6d516a0df4a9e126e3cadef1e5f9d022817f099494d7d8794e4b0fb2" => :yosemite
  end

  option "with-default-names", "Do not prepend 'g' to the binary"
  deprecated_option "default-names" => "with-default-names"

  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
      --infodir=#{info}
      --mandir=#{man}
      --with-packager=Homebrew
    ]

    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats
    if build.without? "default-names" then <<-EOS.undent
      The command has been installed with the prefix "g".
      If you do not want the prefix, install using the "with-default-names"
      option.
      EOS
    end
  end

  test do
    text_file = testpath/"file.txt"
    text_file.write "This line should be matched"
    cmd = build.with?("default-names") ? "grep" : "ggrep"
    grepped = shell_output("#{bin}/#{cmd} match #{text_file}")
    assert_match "should be matched", grepped
  end
end
