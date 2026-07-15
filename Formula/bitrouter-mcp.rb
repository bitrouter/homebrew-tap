class BitrouterMcp < Formula
  desc "BitRouter origin MCP server: exposes complete/list_models/status over stdio and streamable HTTP."
  homepage "https://github.com/bitrouter/bitrouter"
  version "1.0.0-alpha.26"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.26/bitrouter-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "d36a439b580c41fe60b66eeb44c16af42f4fb42838360927bfc51ce52d73ef6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.26/bitrouter-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "df4e75e0ceec1fccd56c25cfc1ee4a4789ac5392493a207381cc31f09cb0e3f1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.26/bitrouter-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e91375f3a0126cd7a2854ab89b685ae9cd3e784eee6e658a390b3f12d98113e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.26/bitrouter-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "05a7f82599a9885e29d4b22a8efe79340dada32d2bcfdbac72de625598ff3abe"
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
