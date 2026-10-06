class SpawnDb < Formula
  desc "Database Build System"
  homepage "https://spawn.dev"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.3.4/spawn-db-aarch64-apple-darwin.tar.xz"
      sha256 "00ea5f8611e239c9276f4de28a1e9d68fb8ef828d14235b8ff59a384bdd3813a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.3.4/spawn-db-x86_64-apple-darwin.tar.xz"
      sha256 "da8069235e5367c863e872d623d0927edf153b7dce0b301087258bae742e577e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.3.4/spawn-db-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "53bfbc45032f775ef4a38bfa7b1655263ed24ae20364f53c539ba78df30cde9f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.3.4/spawn-db-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a7b58c74bd3f2fe41a494076e63984a1aac54c1107ca865fadbf2dd52f949599"
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
