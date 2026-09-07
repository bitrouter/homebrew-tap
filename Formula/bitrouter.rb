class Bitrouter < Formula
  desc "BitRouter: an LLM API router. CLI + assembly library."
  homepage "https://github.com/bitrouter/bitrouter"
  version "1.0.0-alpha.30"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.30/bitrouter-aarch64-apple-darwin.tar.xz"
      sha256 "be1bcf3146a1801a8146cbe32230c0a13b58fb61a0cac0b1d610055eb8595766"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.30/bitrouter-x86_64-apple-darwin.tar.xz"
      sha256 "9355510d7e011865e5c6f8635ecd4d42af6fa78d55c58d19f6b9493fcb3f8c1a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.30/bitrouter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b4b949008515e4760094d7b598a2974f673fcfd38a4f61e4fdf9479920162980"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.30/bitrouter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0909809d2007c94d156daf840de4fcca34dccf5a6b904e50afad2b22617f9984"
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
