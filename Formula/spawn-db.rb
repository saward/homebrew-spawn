class SpawnDb < Formula
  desc "Database Build System"
  homepage "https://spawn.dev"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.2.3/spawn-db-aarch64-apple-darwin.tar.xz"
      sha256 "ae733eafd45409a3d9850e94aa00967f98b01435359dcf2d272ae9ffe789261d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.2.3/spawn-db-x86_64-apple-darwin.tar.xz"
      sha256 "41f8b1aebd88195506eb0eb24b4916714a4768c50ba7c896541249fd73d82625"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/saward/spawn/releases/download/v0.2.3/spawn-db-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f14cd92a48002da44b75a89513df7ccd15e68e43af1e35060ccdb4210d4eb888"
    end
    if Hardware::CPU.intel?
      url "https://github.com/saward/spawn/releases/download/v0.2.3/spawn-db-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b7cd963fae9812447321fec8b8b1c0fb2725e8a4e7f20643e3dc631ed8e7e02f"
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
