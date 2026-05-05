class Bitrouter < Formula
  desc "BitRouter"
  homepage "https://bitrouter.ai"
  version "0.31.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.31.0/bitrouter-aarch64-apple-darwin.tar.xz"
      sha256 "8202acbb915a68a629c50fd958e3d00bd14e43d95ffe372a9058c2dfe08dec44"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.31.0/bitrouter-x86_64-apple-darwin.tar.xz"
      sha256 "1331045d8b11f8ee9ee170e3e152010136241c91460c1695431bd7aeb2ef2585"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.31.0/bitrouter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "feda3a6a83193ff57dc297512847c94db04eddfce48019d6ccf45418bd9ae396"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.31.0/bitrouter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "68e16a2f6daff697d4fc6c7ab26d160c66b4bbd4fff174879b3674cfbdc0b26e"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "bitrouter" if OS.mac? && Hardware::CPU.arm?
    bin.install "bitrouter" if OS.mac? && Hardware::CPU.intel?
    bin.install "bitrouter" if OS.linux? && Hardware::CPU.arm?
    bin.install "bitrouter" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
