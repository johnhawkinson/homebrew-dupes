class Gperf < Formula
  desc "Perfect hash function generator"
  homepage "https://www.gnu.org/software/gperf"
  url "https://ftpmirror.gnu.org/gperf/gperf-3.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz"
  sha256 "588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a29550946fb75b6ec7796c00563038727843edf975c5a1f001e9a2334ea2741" => :el_capitan
    sha256 "b59111d8699e9e005fd8ba71f1c73082801c59618f69e3b6132ef17f4fc3d4d4" => :yosemite
    sha256 "2c96a9dac35ab5cc085d778d0e1fa4899dd0ae2de3120f243a9513761c3eda02" => :mavericks
  end

  keg_only :provided_until_xcode43

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "TOTAL_KEYWORDS 3",
      pipe_output("#{bin}/gperf", "homebrew\nfoobar\ntest\n")
  end
end
