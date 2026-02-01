class SpawnDb < Formula
  desc "Database Build System"
  homepage "https://spawn.dev"
  version "0.1.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.1.10/spawn-db-aarch64-apple-darwin.tar.xz"
      sha256 "b5d2eb11e11e3e0f46ca47a36970e237645234a8e4630e89b883b7fc28fd889e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.1.10/spawn-db-x86_64-apple-darwin.tar.xz"
      sha256 "23042b0254ca0a117811ebad54099251208935237905424fb88b0316037750d0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.1.10/spawn-db-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d4c214312bdda8cc392ecbedb5003e9a551786faebecfe9a9313ca9870a08d8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.1.10/spawn-db-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9b172152e6c680d9afd54989f3e2bc77a0701da0760011fe754159ea2f77f7c9"
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
