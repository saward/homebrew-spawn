class SpawnDb < Formula
  desc "Database Build System"
  homepage "https://spawn.dev"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.1.11/spawn-db-aarch64-apple-darwin.tar.xz"
      sha256 "d403b2af140fe3aaa3b64b49487bb8f1f2c3c3d7d0ef34744255694bfe3d85fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.1.11/spawn-db-x86_64-apple-darwin.tar.xz"
      sha256 "ff3680bd3b737f4aac902c859e5d2eb312f54f98b58da580e0c136f4713f3e5e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.1.11/spawn-db-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20294e6d8fd1ff3dc007c50183a9cff4a7c1c07a9bf10aeea8de7d231a2c3c11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.1.11/spawn-db-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c6b92eeb6343ca284e53d01b153a76ecd39f6441861d16fdd6d8c93cb907a75"
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
