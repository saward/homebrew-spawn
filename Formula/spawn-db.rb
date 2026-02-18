class SpawnDb < Formula
  desc "Database Build System"
  homepage "https://spawn.dev"
  version "0.1.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.1.13/spawn-db-aarch64-apple-darwin.tar.xz"
      sha256 "59fd8d941f648446fb74caa0e32a3650df3edef4c42dcfa9d87c052c7aa40c5d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.1.13/spawn-db-x86_64-apple-darwin.tar.xz"
      sha256 "dcaf3f9b853489c57e9234aa4bc50b5175a4960aad07b006daed658af8ce208e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.1.13/spawn-db-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "415e4d436115f96b6d3a8eefaa27dd268ed4e9def7321bb00f0343c38d75644c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.1.13/spawn-db-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "08746780871781bfcc6c0bf28864d399ac4d67ecdab92d36c5ed6cfd14059a63"
    end
  end
  license "AGPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "spawn" if OS.mac? && Hardware::CPU.arm?
    bin.install "spawn" if OS.mac? && Hardware::CPU.intel?
    bin.install "spawn" if OS.linux? && Hardware::CPU.arm?
    bin.install "spawn" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
