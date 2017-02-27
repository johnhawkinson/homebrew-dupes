class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen"

  stable do
    url "https://ftpmirror.gnu.org/screen/screen-4.5.1.tar.gz"
    mirror "https://ftp.gnu.org/gnu/screen/screen-4.5.1.tar.gz"
    sha256 "97db2114dd963b016cd4ded34831955dcbe3251e5eee45ac2606e67e9f097b2d"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end
  end

  bottle do
    sha256 "ace5e75417b4a81553b4f922fad64103a248654f046bebe723b12b5df2f7cc06" => :sierra
    sha256 "bad02f58fea1157e4298f2e239c75ed335cc6102e2f2d047b2dea9f87455593d" => :el_capitan
    sha256 "2737afb154df0db914c143de6d05ca64a838d1a4ea586e6359f3aa630d360217" => :yosemite
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
