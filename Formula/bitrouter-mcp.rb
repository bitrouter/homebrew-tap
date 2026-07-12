class BitrouterMcp < Formula
  desc "BitRouter origin MCP server: exposes complete/list_models/status over stdio and streamable HTTP."
  homepage "https://github.com/bitrouter/bitrouter"
  version "1.0.0-alpha.25"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.25/bitrouter-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "7f245e85f350bdb00d69074d4c94598a1ef1a64d33aa8f45bf88c0bbc74928c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.25/bitrouter-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "6df51f1349abc76dca04cc0e596cd681077674e5131e83a61898ca342f208457"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.25/bitrouter-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d17f77f488998d28f2232621f60e43331158698f41dda3f766ba0ea013ff11b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.25/bitrouter-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d22d5e6c146ab08b21ccd0096b6e6f1cc62bf10e448b61f9dc503edefad34c97"
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
    bin.install "mcp-stdio-local" if OS.mac? && Hardware::CPU.arm?
    bin.install "mcp-stdio-local" if OS.mac? && Hardware::CPU.intel?
    bin.install "mcp-stdio-local" if OS.linux? && Hardware::CPU.arm?
    bin.install "mcp-stdio-local" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
