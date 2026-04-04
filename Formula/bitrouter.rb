class Bitrouter < Formula
  desc "BitRouter"
  homepage "https://bitrouter.ai"
  version "0.18.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.18.2/bitrouter-aarch64-apple-darwin.tar.xz"
      sha256 "5b6ade380e9b54a1aa82ac40c42db4719a830b8c95c08e75d4fa137bae97385e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.18.2/bitrouter-x86_64-apple-darwin.tar.xz"
      sha256 "b0ae642066ef4d40889ea93bc806e20b1f787fb7dee471c6071013766528bdb7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.18.2/bitrouter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5026013c52d4f4ff630f1e79de81a02e60f31163c15ebfa85d63e19b514928d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.18.2/bitrouter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d7bb12533f3a59cec0e8013080bd20e59fbb8082b13f61cd3e338e79efad8033"
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
