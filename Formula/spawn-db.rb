class SpawnDb < Formula
  desc "Database Build System"
  homepage "https://spawn.dev"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.3.1/spawn-db-aarch64-apple-darwin.tar.xz"
      sha256 "98dd8e0ba4887660f18a751dbdde5486cfb4fb28f232a70b64d0aeeb471da4b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.3.1/spawn-db-x86_64-apple-darwin.tar.xz"
      sha256 "e38ac9f43b5126de131f5c4d2efd151afa70a7d54b9e4b41dfc5742a6256a257"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.3.1/spawn-db-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "33d68c0c07cf0893d3f3476833fca144d6fe4dac9734cea5040a795352ed48b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.3.1/spawn-db-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5ac4dc222b2e3803b5b6f1b88c11381fb14712381e6080e951e3b144a2361ec8"
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
