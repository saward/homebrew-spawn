class SpawnDb < Formula
  desc "Database Build System"
  homepage "https://spawn.dev"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.2.2/spawn-db-aarch64-apple-darwin.tar.xz"
      sha256 "d4a963753a82225a0d952fef2e51b2f00e558afbbf91674b823046e6a284206b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.2.2/spawn-db-x86_64-apple-darwin.tar.xz"
      sha256 "a2f7f9a228860f690dc228affa0135971623a148f68cb9eee413bd9ecf17d1da"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.2.2/spawn-db-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3cce1359e743469349d51fa41dc2e4b59c6a696fe331adc5b7d41c050712d44d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.2.2/spawn-db-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8247df2e7e6c110486dd3062718b1f8f35d7466157131f4a651fe2a4919ab51a"
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
