class Bitrouter < Formula
  desc "BitRouter: an LLM API router. CLI + assembly library."
  homepage "https://github.com/bitrouter/bitrouter"
  version "1.0.0-alpha.29"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.29/bitrouter-aarch64-apple-darwin.tar.xz"
      sha256 "b15ff8fe932a98235e09f9768c471fbfeaf1f4570a0bd0bd7350b656cbe21074"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.29/bitrouter-x86_64-apple-darwin.tar.xz"
      sha256 "ff3119a15e6529c6c5523ea2b0a4239232a71ddf7cda06b23e489f36001fc83b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.29/bitrouter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ea88a4c831208bcdab4dffa1f94394e0a5d921ec4b8379e3ce9460d46082033"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v1.0.0-alpha.29/bitrouter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "56df34e46adf8b9f4d70a6ceda6c3e30e3dbf9da2181bddebeed2b04a49566d5"
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
