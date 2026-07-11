class BitrouterMcp < Formula
  desc "BitRouter origin MCP server: exposes complete/list_models/status over stdio and streamable HTTP."
  homepage "https://github.com/bitrouter/bitrouter"
  version "1.0.0-alpha.24"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.24/bitrouter-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "0b091d33789c2676601462bcad1f166e65074b11d1bb5411dc6e1692dcbf4230"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.24/bitrouter-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "b97db1a090d3ef76bd60f64cab5be8af1500575a53383a5af51f180dae4fb11a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.24/bitrouter-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2cec6cd36de57989eefbf2bb054f001c285249a16390c607af34750e72b72123"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.24/bitrouter-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cb40e0ba32e4f403fedc9b54c552d1b044bf1f3da9e608a8df73ce4e8644fe24"
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
