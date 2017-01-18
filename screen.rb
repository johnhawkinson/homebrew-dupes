class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen"

  stable do
    url "https://ftpmirror.gnu.org/screen/screen-4.5.0.tar.gz"
    mirror "https://ftp.gnu.org/gnu/screen/screen-4.5.0.tar.gz"
    sha256 "01c3a7c362185f35d6a95dff52d64337076496acd034d717de3c263500cfefb0"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end
  end

  bottle do
    sha256 "791f7efb94556fee2535bad543dd3ded0afc85b083fed0ce354c9cf859479cee" => :el_capitan
    sha256 "34713de232c8da57b7af9c38eda55cc9f649dc7713ad3c92a58a7ea23b964af1" => :yosemite
    sha256 "456f6a6a6743c4e0dc1af4793fbe4e8908ba966510f2edeaecf0e46023a5c7e5" => :mavericks
  end

  head do
    url "git://git.savannah.gnu.org/screen.git"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    if build.head?
      cd "src"
    end

    # With parallel build, it fails
    # because of trying to compile files which depend osdef.h
    # before osdef.sh script generates it.
    ENV.deparallelize

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-colors256"
    system "make"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/screen -h", 1)
  end
end
