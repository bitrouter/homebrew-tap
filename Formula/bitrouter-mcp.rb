class BitrouterMcp < Formula
  desc "BitRouter origin MCP server: exposes complete/list_models/status over stdio and streamable HTTP."
  homepage "https://github.com/bitrouter/bitrouter"
  version "1.0.0-alpha.30"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.30/bitrouter-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "39e1352687610aaa003ed46578905283d3afa69dddee673ac5fe7e87714e16b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.30/bitrouter-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "47de50c810af7068a977c4c7354d15177d26bec50db92cc8a77d413811bb6c3a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.30/bitrouter-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e462709b309efbfd41c4a2b3f9dc6bb42879a8925f1bb806efcb2969195c04e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.30/bitrouter-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0e74a29ce98d7a7c1d6ef52c2af04a47a0732710936feb980994b252c4ff8490"
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
      bin.install "mcp-stdio-local"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "mcp-stdio-local"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "mcp-stdio-local"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "mcp-stdio-local"
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
