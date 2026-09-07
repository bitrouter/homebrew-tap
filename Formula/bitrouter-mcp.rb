class BitrouterMcp < Formula
  desc "BitRouter origin MCP server: exposes complete/list_models/status over stdio and streamable HTTP."
  homepage "https://github.com/bitrouter/bitrouter"
  version "1.0.0-alpha.29"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.29/bitrouter-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "b4e74cc12fc5a44d55b152da32bda8ba33c940494094033cb15d6adabf5319cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.29/bitrouter-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "25da1fd608398a78933d715185769ab1187ae6d71cbef0f7f7ec21f2fe31213f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.29/bitrouter-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9df101ed976a5a78ed30d33e191b6049ee6d98ae77e895ba053eb0ab1a69e3a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.29/bitrouter-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "48068fffba125c6ce79217b0112d2f7d59baf33e7e7380bacb3b4f89bbded9a1"
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
