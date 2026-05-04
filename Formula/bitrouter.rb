class Bitrouter < Formula
  desc "BitRouter"
  homepage "https://bitrouter.ai"
  version "0.30.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.30.0/bitrouter-aarch64-apple-darwin.tar.xz"
      sha256 "1aaf86216ddc964741647a3c530d8ecaeedb8b8556d61abb45a4b9d4876c2b8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.30.0/bitrouter-x86_64-apple-darwin.tar.xz"
      sha256 "48ea0f3a3f16feb00859eb12fb3fd41ed730866b06ff423a6096305d6c62ac8f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.30.0/bitrouter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "60cc466562db1aec99efa58427b7471f33757a8f70010409bc2155bd0248d3a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.30.0/bitrouter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3159f23675817f1a49526a4e43303ab1eaf1dd8299a8df725eb1f61725b66149"
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
