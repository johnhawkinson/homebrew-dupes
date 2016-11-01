class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "http://www.openldap.org/software/"
  url "ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.44.tgz"
  mirror "http://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.44.tgz"
  sha256 "d7de6bf3c67009c95525dde3a0212cc110d0a70b92af2af8e3ee800e81b88400"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8b55762758ce839c54a427462bd311cf9604be6258b5c07dfc65e779a70ed1b2" => :sierra
    sha256 "bcbe0d00fc34d029211b5de10a68bbdb0be078c3197039356e4d0f25d01e82f2" => :el_capitan
    sha256 "95bb3356c3b5c61be00583cd0351a538dc0f017db25c6cf054badd0756e56e9c" => :yosemite
  end

  keg_only :provided_by_osx

  option "with-sssvlv", "Enable server side sorting and virtual list view"

  depends_on "berkeley-db4" => :optional
  depends_on "groff" => :build unless OS.mac?
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-accesslog
      --enable-auditlog
      --enable-constraint
      --enable-dds
      --enable-deref
      --enable-dyngroup
      --enable-dynlist
      --enable-memberof
      --enable-ppolicy
      --enable-proxycache
      --enable-refint
      --enable-retcode
      --enable-seqmod
      --enable-translucent
      --enable-unique
      --enable-valsort
    ]

    args << "--enable-bdb=no" << "--enable-hdb=no" if build.without? "berkeley-db4"
    args << "--enable-sssvlv=yes" if build.with? "sssvlv"

    system "./configure", *args
    system "make", "install"
    (var+"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, Dir[etc/"openldap/*"]
    chmod 0755, Dir[etc/"openldap/schema/*"]
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
