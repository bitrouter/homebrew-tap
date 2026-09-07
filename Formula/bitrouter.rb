class Bitrouter < Formula
  desc "BitRouter: an LLM API router. CLI + assembly library."
  homepage "https://github.com/bitrouter/bitrouter"
  version "1.0.0-alpha.28"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.28/bitrouter-aarch64-apple-darwin.tar.xz"
      sha256 "b104e5233bf5a6f70f2aeb6b1b81b1e8c182ec78393617e9195cc4aca9920dee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.28/bitrouter-x86_64-apple-darwin.tar.xz"
      sha256 "2a0be1739bf78abbd1858cb42c3200b62b237c0f2d03000bb82a364744dbe0d6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.28/bitrouter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20e1fb9fd1158c49e8ec9e24643e2b8ee5e5d8b226c0e471168f245c840eb332"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.28/bitrouter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f3f3a6daf91a3bcf337c03fb460bd3c2040b1b541ec28d31767251f9ae69fd69"
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
