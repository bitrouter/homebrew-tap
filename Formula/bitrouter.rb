class Bitrouter < Formula
  desc "BitRouter: an LLM API router. CLI + TUI + assembly library."
  homepage "https://github.com/bitrouter/bitrouter"
  version "1.0.0-alpha.21"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.21/bitrouter-aarch64-apple-darwin.tar.xz"
      sha256 "bd2ccb3777db9bd2f55ca7a5ff2e45e598730c2ddde0ee3216549ae4698b98f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.21/bitrouter-x86_64-apple-darwin.tar.xz"
      sha256 "4e5df9cf37f459ab08c2096bf71e6dc080d20437f94b9f44340f2e389a8ea750"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.21/bitrouter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "877a2687018716d5f1e605b1d04224689e83486c3d8f4dea8d2a93d0b4fe9d46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.21/bitrouter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8154510090b29a4a5ab5a1e4f4bd650ebbec46f9904b45c27ff6b2d8cb676b0a"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "bitrouter"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "bitrouter"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "bitrouter"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "bitrouter"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
