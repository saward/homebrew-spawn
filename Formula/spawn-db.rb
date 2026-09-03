class SpawnDb < Formula
  desc "Database Build System"
  homepage "https://spawn.dev"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.2.4/spawn-db-aarch64-apple-darwin.tar.xz"
      sha256 "eb36081235450ca2a79b2f7dfe44265c755a04c795cc4a6b79b610ae378cd2a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.2.4/spawn-db-x86_64-apple-darwin.tar.xz"
      sha256 "f12b026fcc808c271375fcfcfd323675010c7eaea41a56509f2562718289749b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.2.4/spawn-db-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ea9bd028f6106663a604d58b7ec5bdcce40796efd9bfa842a388349ec1c2bd23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.2.4/spawn-db-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "697c994fe1c8fb5688666291dc65b699e73c689a1da0029cbcfb87ba2c6bd822"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "spawn"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "spawn"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "spawn"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "spawn"
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
