class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "http://www.netlib.org/lapack/"
  url "http://www.netlib.org/lapack/lapack-3.7.0.tgz"
  sha256 "ed967e4307e986474ab02eb810eed1d1adc73f5e1e3bc78fb009f6fe766db3be"
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    sha256 "c4d56d7d4b5288d7629392239dea020e918fa3fdaf286cf046116d3afda2d6e1" => :el_capitan
    sha256 "135069ff3f5ec2ca7ce0dc6d430ec3b05a8df07c32758f0008af18a04e7963a7" => :yosemite
    sha256 "46d218675c35154e8435189fd15eb164b6317bb823402f4f7adba5c8ebd5547a" => :mavericks
  end

  keg_only :provided_by_osx

  option "with-doxygen", "Build man pages with Doxygen"

  depends_on "cmake" => :build
  depends_on :fortran
  depends_on "gcc"
  depends_on "doxygen" => [:build, :optional, "with-llvm"]

  def install
    if build.with? "doxygen"
      mv "make.inc.example", "make.inc"
      system "make", "man"
      man3.install Dir["DOCS/man/man3/*"]
    end
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS:BOOL=ON", "-DLAPACKE:BOOL=ON",
             *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"lp.cpp").write <<-EOS.undent
      #include "lapacke.h"
      int main() {
        void *p = LAPACKE_malloc(sizeof(char)*100);
        if (p) {
          LAPACKE_free(p);
        }
        return 0;
      }
    EOS
    system ENV.cc, "lp.cpp", "-I#{include}", "-L#{lib}", "-llapacke", "-o", "lp"
    system "./lp"
  end
end
