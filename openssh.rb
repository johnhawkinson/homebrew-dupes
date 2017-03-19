class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "https://www.openssh.com/"
  url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.4p1.tar.gz"
  mirror "https://www.mirrorservice.org/pub/OpenBSD/OpenSSH/portable/openssh-7.4p1.tar.gz"
  version "7.4p1"
  sha256 "1b1fc4a14e2024293181924ed24872e6f2e06293f3e8926a376b8aec481f19d1"

  bottle do
    sha256 "dc1399c974bd93b13c2a7814cc3ee94a26b58336ec96d47e33bfd6913446793c" => :sierra
    sha256 "eab9307dc45d0f2438492e582eb5d6d5c47a959e8c2ddd9999b23a366bd25907" => :el_capitan
    sha256 "901f3961cd36001559e988c43fc46d17fdd8d358cfc876a5bddae96120dfaed8" => :yosemite
  end

  # Please don't resubmit the keychain patch option. It will never be accepted.
  # https://github.com/Homebrew/homebrew-dupes/pull/482#issuecomment-118994372
  option "with-libressl", "Build with LibreSSL instead of OpenSSL"

  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional
  depends_on "ldns" => :optional
  depends_on "pkg-config" => :build if build.with? "ldns"
  unless OS.mac?
    depends_on "homebrew/dupes/libedit"
    depends_on "homebrew/dupes/krb5"
  end

  if OS.mac?
    # Both these patches are applied by Apple.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/1860b0a74/openssh/patch-sandbox-darwin.c-apple-sandbox-named-external.diff"
      sha256 "d886b98f99fd27e3157b02b5b57f3fb49f43fd33806195970d4567f12be66e71"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/d8b2d8c2/openssh/patch-sshd.c-apple-sandbox-named-external.diff"
      sha256 "3505c58bf1e584c8af92d916fe5f3f1899a6b15cc64a00ddece1dc0874b2f78f"
    end

    # Patch for SSH tunnelling issues caused by launchd changes on Yosemite
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/d8b2d8c2/OpenSSH/launchd.patch"
      sha256 "df61404042385f2491dd7389c83c3ae827bf3997b1640252b018f9230eab3db3"
    end
  end

  def install
    ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__" if OS.mac?

    args = %W[
      --with-libedit
      --with-kerberos5
      --prefix=#{prefix}
      --sysconfdir=#{etc}/ssh
    ]
    args << "--with-pam" if OS.mac?
    args << "--with-privsep-path=#{var}/lib/sshd" if OS.linux?

    if build.with? "libressl"
      args << "--with-ssl-dir=#{Formula["libressl"].opt_prefix}"
    else
      args << "--with-ssl-dir=#{Formula["openssl"].opt_prefix}"
    end

    args << "--with-ldns" if build.with? "ldns"

    system "./configure", *args
    system "make"
    system "make", "install"

    # This was removed by upstream with very little announcement and has
    # potential to break scripts, so recreate it for now.
    # Debian have done the same thing.
    bin.install_symlink bin/"ssh" => "slogin"
  end
end
