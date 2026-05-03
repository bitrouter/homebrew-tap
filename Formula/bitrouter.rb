class Bitrouter < Formula
  desc "BitRouter"
  homepage "https://bitrouter.ai"
  version "0.28.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.28.0/bitrouter-aarch64-apple-darwin.tar.xz"
      sha256 "533928ba6583cb9eac0c1898b42b842d4511315e061e9ee81a8ff73049462a9f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.28.0/bitrouter-x86_64-apple-darwin.tar.xz"
      sha256 "d8ac97a1782d1b95685f9a41cd0ca3d5af5c5c4ce169154181d38335b9003ecb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.28.0/bitrouter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "470cce56e11c4124d34dbfeb8a1cc6dfe6c5d5c1a91e9f3bba1cb7000286afb7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.28.0/bitrouter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "32ad5eaba984d714d2a500e63fb3cb663ff071c029b83e6e1d7722425746f3b1"
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
