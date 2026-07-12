class Bitrouter < Formula
  desc "BitRouter: an LLM API router. CLI + TUI + assembly library."
  homepage "https://github.com/bitrouter/bitrouter"
  version "1.0.0-alpha.25"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.25/bitrouter-aarch64-apple-darwin.tar.xz"
      sha256 "ab16293450260440265259e598c379d580833d57001908825d9062ce917a819d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.25/bitrouter-x86_64-apple-darwin.tar.xz"
      sha256 "8b320fa9dd7366c83f95e1dcff813e4fdf102cdf2abeca5c474df092bdad7e19"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.25/bitrouter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3e2c4c9afd4c0d3d5535f052356e392a713faabda7aed65cdbc887e930099b50"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.25/bitrouter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "88e9356370f85c9d4ff82c9663a5fafa3e940a10f25e37446fdb21c5e6b14f5b"
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
