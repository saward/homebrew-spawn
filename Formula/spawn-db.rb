class SpawnDb < Formula
  desc "Database Build System"
  homepage "https://spawn.dev"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.1.7/spawn-db-aarch64-apple-darwin.tar.xz"
      sha256 "c24903a2e1607e9736567df8b74ce2da10b61547c79b3195fc6e35a450c89581"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.1.7/spawn-db-x86_64-apple-darwin.tar.xz"
      sha256 "d1a632c3ae720f58988e217eda78d00a6ed2aed9de39e97881c2bed08e620fee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.1.7/spawn-db-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "90c4bd9e71e0797b0e9e2bbaaa378cf3e87f7ba16e7313edd4aa2c5f78235757"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.1.7/spawn-db-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "08d4217826ede890e5936cbb0097a180200d09feac6cabe8b0dd00e185218994"
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
