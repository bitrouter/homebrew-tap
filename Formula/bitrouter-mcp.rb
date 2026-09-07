class BitrouterMcp < Formula
  desc "BitRouter origin MCP server: exposes complete/list_models/status over stdio and streamable HTTP."
  homepage "https://github.com/bitrouter/bitrouter"
  version "1.0.0-alpha.28"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.28/bitrouter-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "7a8e9415868721921e31cb5cdf9d78c77d028fc86bbef365037d15d849999567"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.28/bitrouter-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "6c0f77aea22383ddb60dceed41d8f51989ba3627256f1294a7f5fc60a72cf037"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.28/bitrouter-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "81c28dd627ccf049ba4f4de2cf291e7e21dd6af5c6c09c3ba3b6dd6bdfaa3983"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.28/bitrouter-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c617a752b704484aa06291d4682f35c58912080b7143798deabec61d6be995de"
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
