class Bitrouter < Formula
  desc "BitRouter: an LLM API router. CLI + TUI + assembly library."
  homepage "https://github.com/bitrouter/bitrouter"
  version "1.0.0-alpha.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.4/bitrouter-aarch64-apple-darwin.tar.xz"
      sha256 "384120622822f1bdab6bee3418680f17372acba733beb53b7693dbbc7d89edc7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.4/bitrouter-x86_64-apple-darwin.tar.xz"
      sha256 "54b0074971f8b0b112163ee3fdeedeea02e0253c177711b82bd6252e51f2a625"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.4/bitrouter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c0894e0d16e9aa882bad7f880d2d02c1a5a62efedaaa0647a2de2fd511b66f2b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.4/bitrouter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2a3c14983f31b47dae19fea036454c5ae91f8aeb9f16bb4d50f03d70870c24f4"
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
