class SpawnDb < Formula
  desc "Database Build System"
  homepage "https://spawn.dev"
  version "0.1.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.1.12/spawn-db-aarch64-apple-darwin.tar.xz"
      sha256 "eec39cc3d3bea8a47ebd12e765acfebb5a1b784cf008c2f884cb040186aa40ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.1.12/spawn-db-x86_64-apple-darwin.tar.xz"
      sha256 "d5b54f1a1bd8b62ec7d6866133f5efd4e83ee5a974728addba7133b315408af2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.1.12/spawn-db-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a5c9e03b756f1470920ebe30ccc525c28f2b267ec40e3cd28e41baa3161a7346"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.1.12/spawn-db-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7a1d94f43298edb858aa0c5ec425c1d700ab3a18b25d7cc51ffd56b4f5aacf49"
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
