require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php70PdoFirebird < AbstractPhp70Extension
  init
  desc "A unified Firebird driver for PDO"
  homepage "https://github.com/php/php-src/tree/master/ext/pdo_firebird"
  bottle do
    cellar :any
    sha256 "48a7e3df2399ad6a83de85461e65cd95ce9be2effd41c4075d792ec7349c3607" => :el_capitan
    sha256 "e0651f8238e8872bb4a1533021e8cc3370e10c6f9c29748f3b9da4d4d87672a7" => :yosemite
    sha256 "c748aa9255ee3310b3a22ade735cdadcf9b3e6310ba60c9f2c77d4c29468b3f7" => :mavericks
  end

  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]
  version PHP_VERSION

  #depends_on "firebirdsql" //Needs to have firebirdsql created

  def extension
    "pdo_firebird"
  end

  def install
    Dir.chdir "ext/pdo_firebird"
    
    ENV.universal_binary if build.universal?
    
    safe_phpize
    
    #Hack around not finding ibase.h problem
    system "cp /Library/Frameworks/Firebird.framework/Headers/* ."
    system "./configure", "--prefix=#{prefix}", "--with-pdo-firebird=/Library/Frameworks/Firebird.framework/", phpconfig
    system "make"
    prefix.install "modules/pdo_firebird.so"
    write_config_file if build.with? "config-file"
  end
end
