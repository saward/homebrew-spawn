class SpawnDb < Formula
  desc "Database Build System"
  homepage "https://spawn.dev"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.3.2/spawn-db-aarch64-apple-darwin.tar.xz"
      sha256 "ef429e8bc4048c426cfd4cbdf31db4aea80f9c5580820f9ff52af7db24338483"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.3.2/spawn-db-x86_64-apple-darwin.tar.xz"
      sha256 "8dc92477d03bbdcd04eca664f8f7e7b3f3d03a6120439a1061723ad1fec686f9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.3.2/spawn-db-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e6bcd0dbdd109c4fb741739a92e3cadf47e32b9c36123f42decb988c67507233"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.3.2/spawn-db-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4dc4f3fef15fc8fabf03cbc39dce27bac04f064fc276d865e3c5d85d4fc555ea"
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
