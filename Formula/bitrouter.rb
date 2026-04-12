class Bitrouter < Formula
  desc "BitRouter"
  homepage "https://bitrouter.ai"
  version "0.22.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.22.1/bitrouter-aarch64-apple-darwin.tar.xz"
      sha256 "722f5797a8b0dfe29ac8f39fd16d0e5def2af34d97d7f64d18887b538bba0726"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.22.1/bitrouter-x86_64-apple-darwin.tar.xz"
      sha256 "3652f984dfb492900ed9a44300e4b0f7cda4c1cece846d215cdea178ef4f3e98"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.22.1/bitrouter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "98ccac94b163869387fabcf4fc998c11f649213f7922031014f2cfd252c923b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bitrouter/bitrouter/releases/download/v0.22.1/bitrouter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "902aa44d699bad16e933703ff5b19a99fe217c85f151abc0d62294d7a61aec8c"
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
