class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "http://www.netlib.org/lapack/"
  url "http://www.netlib.org/lapack/lapack-3.7.0.tgz"
  sha256 "ed967e4307e986474ab02eb810eed1d1adc73f5e1e3bc78fb009f6fe766db3be"
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    sha256 "06af7eef33ca3c067c0d68f0913e5c4920d6106986356ef37db9cc39451d0f05" => :sierra
    sha256 "6a83edd0736fc8d499b355870f328d36a722b05b04303bbf7a48260ef7e964cb" => :el_capitan
    sha256 "5f7584fd063174c84e0bd2374d1d021e1efd64a28b2b03d3ddb8b4a6ad14c4e8" => :yosemite
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
