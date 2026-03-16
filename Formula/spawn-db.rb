class SpawnDb < Formula
  desc "Database Build System"
  homepage "https://spawn.dev"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.2.0/spawn-db-aarch64-apple-darwin.tar.xz"
      sha256 "d675743f96883d28872eabf5c54feaca4f889f99a62a01821a911db16deb4f18"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.2.0/spawn-db-x86_64-apple-darwin.tar.xz"
      sha256 "a3cdb85ec3f5cce1c0c35354b40e7330a09096191cd42ebee286d704a7fc03e0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.2.0/spawn-db-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7be996011cfb1694516457f76199cdcb84a0fc42c5fac07ec26cf27600e32b5b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.2.0/spawn-db-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7b0ed244fdfb3ae40aab85758896b3b457dffe34d036b56d2147c3e4346d7295"
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
