class SpawnDb < Formula
  desc "Database Build System"
  homepage "https://spawn.dev"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.3.3/spawn-db-aarch64-apple-darwin.tar.xz"
      sha256 "49ab01d0451024e73e30a8f3ceee2cd958ad214295b89b68018a594aea38d8ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.3.3/spawn-db-x86_64-apple-darwin.tar.xz"
      sha256 "9c70f190e2cd5ba978348a7e5ceb0ad844e47dd5435e797f0912489f9137c36b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.3.3/spawn-db-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0a8e0f0725ae4efb9bf0dc971207198c0ba949dd371254d3f469868711534c96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.3.3/spawn-db-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "11af3d90c892ecbc046a45f420051a3321442f0afac363aed8cc0a40c3eff4aa"
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
